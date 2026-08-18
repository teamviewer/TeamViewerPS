function New-TeamViewerUser {
    [CmdletBinding(SupportsShouldProcess = $true, DefaultParameterSetName = 'WithPassword')]

    [OutputType('TeamViewerPS.User')]

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
        [ValidateScript( { $_ | Resolve-TeamViewerLanguage } )]
        [cultureinfo]
        $Culture,

        [Parameter()]
        [ValidateScript({ $_ | Resolve-TeamViewerRoleId })]
        [object]
        $RoleId,


        [Parameter()]
        [bool]
        $Active,

        [Parameter()]
        [bool]
        $LogSessions,

        [Parameter()]
        [bool]
        $ShowCommentWindow,

        [Parameter()]
        [bool]
        $SubscribeNewsletter,

        [Parameter()]
        [string]
        $CustomQuickSupportId,

        [Parameter()]
        [string]
        $CustomQuickJoinId,

        [Parameter()]
        [string]
        $LicenseKey,

        [Parameter()]
        [string]
        $MeetingLicenseKey,

        [Parameter()]
        [switch]
        $IgnorePredefinedRole
    )

    if (-not $Culture) {
        try {
            $Culture = Get-Culture
        }
        catch {
            $Culture = 'en'
        }
    }

    $Body = @{
        email    = $Email
        name     = $Name
        language = $Culture | Resolve-TeamViewerLanguage
    }

    if ($Password -and -not $WithoutPassword) {
        $bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password)
        $Body['password'] = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($bstr)
        [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr) | Out-Null
    }

    if ($SsoCustomerIdentifier) {
        $bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SsoCustomerIdentifier)
        $Body['sso_customer_id'] = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($bstr)
        [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr) | Out-Null
    }

    if ($RoleId) {
        $Body['userRoleId'] = $RoleId | Resolve-TeamViewerRoleId
    }

    if ($IgnorePredefinedRole) {
        $Body['ignorePredefinedRole'] = $true
    }

    if ($PSBoundParameters.ContainsKey('Active')) {
        $Body['active'] = $Active
    }

    if ($PSBoundParameters.ContainsKey('LogSessions')) {
        $Body['log_sessions'] = $LogSessions
    }

    if ($PSBoundParameters.ContainsKey('ShowCommentWindow')) {
        $Body['show_comment_window'] = $ShowCommentWindow
    }

    if ($PSBoundParameters.ContainsKey('SubscribeNewsletter')) {
        $Body['subscribe_newsletter'] = $SubscribeNewsletter
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

    if ($PSBoundParameters.ContainsKey('MeetingLicenseKey')) {
        $Body['meeting_license_key'] = $MeetingLicenseKey
    }

    $ResourceUri = "$(Get-TeamViewerApiUri)/users"

    if ($PSCmdlet.ShouldProcess("$Name <$Email>", 'Create user')) {
        $Response = Invoke-TeamViewerRestMethod -ApiToken $ApiToken -Uri $ResourceUri -Method Post -ContentType 'application/json; charset=utf-8' `
            -Body ([System.Text.Encoding]::UTF8.GetBytes(($Body | ConvertTo-Json))) -WriteErrorTo $PSCmdlet -ErrorAction Stop
        $Result = ($Response | ConvertTo-TeamViewerUser)
        $Result.Email = $Email

        Write-Output $Result
    }
}
