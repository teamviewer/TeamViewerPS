function Set-TeamViewerUser {
    [CmdletBinding(SupportsShouldProcess = $true, DefaultParameterSetName = 'ByParameters')]

    [OutputType([void])]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $APIToken,

        [Parameter(Mandatory = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerUserId } )]
        [Alias('Id', 'UserId')]
        [object]
        $User,

        [Parameter(ParameterSetName = 'ByParameters')]
        [boolean]
        $Active,

        [Parameter(ParameterSetName = 'ByParameters')]
        [Alias('EmailAddress')]
        [string]
        $Email,

        [Parameter(ParameterSetName = 'ByParameters')]
        [Alias('DisplayName')]
        [string]
        $Name,

        [Parameter(ParameterSetName = 'ByParameters')]
        [securestring]
        $Password,

        [Parameter(ParameterSetName = 'ByParameters')]
        [securestring]
        $SSO_CustomerIdentifier,

        [Parameter(ParameterSetName = 'ByParameters')]
        [bool]
        $LogSessions,

        [Parameter(ParameterSetName = 'ByParameters')]
        [bool]
        $ShowCommentWindow,

        [Parameter(ParameterSetName = 'ByParameters')]
        [bool]
        $TFAEnforcement,

        [Parameter(ParameterSetName = 'ByParameters')]
        [string]
        $CustomQuickSupportId,

        [Parameter(ParameterSetName = 'ByParameters')]
        [string]
        $CustomQuickJoinId,

        [Parameter(ParameterSetName = 'ByParameters')]
        [string]
        $LicenseKey,

        [Parameter(Mandatory = $true, ParameterSetName = 'ByProperties')]
        [hashtable]
        $Properties,

        [Parameter()]
        [ValidateScript({ $_ | Resolve-TeamViewerRoleId })]
        [string[]]
        $AddRole,

        [Parameter()]
        [ValidateScript({ $_ | Resolve-TeamViewerRoleId })]
        [string[]]
        $RemoveRole
    )

    $Body = @{}

    switch ($PSCmdlet.ParameterSetName) {
        'ByParameters' {
            if ($PSBoundParameters.ContainsKey('Active')) {
                $Body['active'] = $Active
            }

            if ($Email) {
                $Body['email'] = $Email
            }

            if ($Name) {
                $Body['name'] = $Name
            }

            if ($Password) {
                $bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password)
                $Body['password'] = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($bstr)
                [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr) | Out-Null
            }

            if ($SSO_CustomerIdentifier) {
                $bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SSO_CustomerIdentifier)
                $Body['sso_customer_id'] = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($bstr)
                [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr) | Out-Null
            }

            if ($AddRole) {
                $Body['assignUserRoleIds'] = @($AddRole)
            }

            if ($RemoveRole) {
                $Body['unassignUserRoleIds'] = @($RemoveRole)
            }

            if ($PSBoundParameters.ContainsKey('LogSessions')) {
                $Body['log_sessions'] = $LogSessions
            }

            if ($PSBoundParameters.ContainsKey('ShowCommentWindow')) {
                $Body['show_comment_window'] = $ShowCommentWindow
            }

            if ($PSBoundParameters.ContainsKey('TFAEnforcement')) {
                $Body['tfa_enforcement'] = $TFAEnforcement
            }

            if ($PSBoundParameters.ContainsKey('CustomQuickSupportId')) {
                $Body['custom_quicksupport_id'] = $CustomQuickSupportId
            }

            if ($PSBoundParameters.ContainsKey('CustomQuickJoinId')) {
                $Body['custom_quickjoin_id'] = $CustomQuickJoinId
            }

            if ($PSBoundParameters.ContainsKey('LicenseKey')) {
                $Body['license_key'] = $LicenseKey
            }

        }
        'ByProperties' {
            @('active', 'email', 'name', 'password', 'sso_customer_id', 'permissions', 'tfa_enforcement' , 'license_key', 'custom_quickjoin_id', 'custom_quicksupport_id', 'show_comment_window', 'log_sessions' , 'assignUserRoleIds', 'unassignUserRoleIds') | `
                Where-Object { $Properties[$_] } | `
                ForEach-Object { $Body[$_] = $Properties[$_] }
        }
    }

    if ($Body.Count -eq 0) {
        $PSCmdlet.ThrowTerminatingError(
            ('The given input does not change the user.' | ConvertTo-ErrorRecord -ErrorCategory InvalidArgument))
    }

    $userId = Resolve-TeamViewerUserId -User $User
    $Resource_Uri = "$(Get-TeamViewerAPIUri)/users/$userId"

    if ($PSCmdlet.ShouldProcess($userId, 'Update user')) {
        Invoke-TeamViewerRestMethod -APIToken $APIToken -Uri $Resource_Uri -Method Put -ContentType 'application/json; charset=utf-8' `
            -Body ([System.Text.Encoding]::UTF8.GetBytes(($Body | ConvertTo-Json))) -WriteErrorTo $PSCmdlet | Out-Null
    }
}
