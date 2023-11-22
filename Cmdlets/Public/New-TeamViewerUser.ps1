function New-TeamViewerUser {
    [CmdletBinding(SupportsShouldProcess = $true, DefaultParameterSetName = 'WithPassword')]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true)]
        [Alias('EmailAddress')]
        [string]
        $Email,

        [Parameter(Mandatory = $true)]
        [Alias('DisplayName')]
        [string]
        $Name,

        [Parameter(Mandatory = $true, ParameterSetName = 'WithPassword')]
        [securestring]
        $Password,

        [Parameter(ParameterSetName = 'WithoutPassword')]
        [Alias('NoPassword')]
        [switch]
        $WithoutPassword,

        [Parameter()]
        [securestring]
        $SsoCustomerIdentifier,

        [Parameter()]
        [array]
        $Permissions,

        [Parameter()]
        [ValidateScript( { $_ | Resolve-TeamViewerLanguage } )]
        [cultureinfo]
        $Culture,

        [Parameter()]
        [ValidateScript({ $_ | Resolve-TeamViewerRoleId })]
        [object]
        $RoleId,

        [Parameter()]
        [switch]
        $IgnorePredefinedRole
    )

    if (-Not $Culture) {
        try {
            $Culture = Get-Culture
        }
        catch {
            $Culture = 'en'
        }
    }

    $body = @{
        email    = $Email
        name     = $Name
        language = $Culture | Resolve-TeamViewerLanguage
        permissions = $Permissions -join ','
    }

    if ($Password -And -Not $WithoutPassword) {
        $bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password)
        $body['password'] = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($bstr)
        [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr) | Out-Null
    }

    if ($SsoCustomerIdentifier) {
        $bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SsoCustomerIdentifier)
        $body['sso_customer_id'] = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($bstr)
        [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr) | Out-Null
    }

    if($RoleId){
        $body['userRoleId'] = $RoleId | Resolve-TeamViewerRoleId
    }

    if($IgnorePredefinedRole){
        $body['ignorePredefinedRole'] = $true
    }

    $resourceUri = "$(Get-TeamViewerApiUri)/users"
    if ($PSCmdlet.ShouldProcess("$Name <$Email>", 'Create user')) {
        $response = Invoke-TeamViewerRestMethod -ApiToken $ApiToken -Uri $resourceUri -Method Post -ContentType 'application/json; charset=utf-8' `
            -Body ([System.Text.Encoding]::UTF8.GetBytes(($body | ConvertTo-Json))) -WriteErrorTo $PSCmdlet -ErrorAction Stop
        $result = ($response | ConvertTo-TeamViewerUser)
        $result.Email = $Email

        Write-Output $result
    }
}
