function Set-TeamViewerUser {
    [CmdletBinding(SupportsShouldProcess = $true, DefaultParameterSetName = 'ByParameters')]

    [OutputType([void])]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerUserId } )]
        [Alias('UserId')]
        [Alias('Id')]
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
        $SsoCustomerIdentifier,

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
        $Property,

        [Parameter()]
        [Alias('AssignRole')]
        [ValidateScript({ $_ | Resolve-TeamViewerRoleId })]
        [string[]]
        $AssignRoleId,

        [Parameter()]
        [Alias('UnassignRole')]
        [ValidateScript({ $_ | Resolve-TeamViewerRoleId })]
        [string[]]
        $UnassignRoleId
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

            if ($SsoCustomerIdentifier) {
                $bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SsoCustomerIdentifier)
                $Body['sso_customer_id'] = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($bstr)
                [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr) | Out-Null
            }

            if ($AssignRoleId) {
                $Body['assignUserRoleIds'] = @($AssignRoleId)
            }

            if ($UnassignRoleId) {
                $Body['unassignUserRoleIds'] = @($UnassignRoleId)
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
            @('active', 'email', 'name', 'password', 'sso_customer_id', 'permissions', 'tfa_enforcement' , 'license_key', 'custom_quickjoin_id', 'custom_quicksupport_id', 'show_comment_window', 'log_sessions' , 'AssignUserRoleIds', 'UnassignUserRoleIds') | `
                Where-Object { $Property[$_] } | `
                ForEach-Object { $Body[$_] = $Property[$_] }
        }
    }

    if ($Body.Count -eq 0) {
        $PSCmdlet.ThrowTerminatingError(
            ('The given input does not change the user.' | `
                ConvertTo-ErrorRecord -ErrorCategory InvalidArgument))
    }

    $userId = Resolve-TeamViewerUserId -User $User
    $ResourceUri = "$(Get-TeamViewerApiUri)/users/$userId"

    if ($PSCmdlet.ShouldProcess($userId, 'Update user')) {
        Invoke-TeamViewerRestMethod -ApiToken $ApiToken -Uri $ResourceUri -Method Put -ContentType 'application/json; charset=utf-8' `
            -Body ([System.Text.Encoding]::UTF8.GetBytes(($Body | ConvertTo-Json))) -WriteErrorTo $PSCmdlet | Out-Null
    }
}
