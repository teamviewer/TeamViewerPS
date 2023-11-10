function Set-TeamViewerUser {
    [CmdletBinding(SupportsShouldProcess = $true, DefaultParameterSetName = 'ByParameters')]
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

    $body = @{}
    switch ($PSCmdlet.ParameterSetName) {
        'ByParameters' {
            if ($PSBoundParameters.ContainsKey('Active')) {
                $body['active'] = $Active
            }
            if ($Email) {
                $body['email'] = $Email
            }
            if ($Name) {
                $body['name'] = $Name
            }
            if ($Password) {
                $bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password)
                $body['password'] = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($bstr)
                [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr) | Out-Null
            }
            if ($SsoCustomerIdentifier) {
                $bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SsoCustomerIdentifier)
                $body['sso_customer_id'] = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($bstr)
                [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr) | Out-Null
            }
            if($AssignRoleId){
                $body['assignUserRoleIds'] = @($AssignRoleId)
            }
            if($UnassignRoleId){
                $body['unassignUserRoleIds'] = @($UnassignRoleId)
            }
        }
        'ByProperties' {
            @('active', 'email', 'name', 'password', 'sso_customer_id') | Where-Object { $Property[$_] } | ForEach-Object { $body[$_] = $Property[$_] }
        }
    }

    if ($body.Count -eq 0) {
        $PSCmdlet.ThrowTerminatingError(
            ('The given input does not change the user.' | `
                ConvertTo-ErrorRecord -ErrorCategory InvalidArgument))
    }

    $userId = Resolve-TeamViewerUserId -User $User
    $resourceUri = "$(Get-TeamViewerApiUri)/users/$userId"

    if ($PSCmdlet.ShouldProcess($userId, 'Update user profile')) {
        Invoke-TeamViewerRestMethod -ApiToken $ApiToken -Uri $resourceUri -Method Put -ContentType 'application/json; charset=utf-8' `
            -Body ([System.Text.Encoding]::UTF8.GetBytes(($body | ConvertTo-Json))) -WriteErrorTo $PSCmdlet | Out-Null
    }
}
