function Add-TeamViewerSSOInclusion {
    [CmdletBinding(SupportsShouldProcess = $true)]

    [OutputType([void])]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $APIToken,

        [Parameter(Mandatory = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerSSODomainId } )]
        [Alias('Id', 'DomainId', 'SSODomainId', 'SSODomain')]
        [object]
        $Domain,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [Alias('EmailAddress')]
        [string[]]
        $Email
    )

    begin {
        $Domain_Id = $Domain | Resolve-TeamViewerSSODomainId

        $Resource_Uri = "$(Get-TeamViewerAPIUri)/ssoDomain/$Domain_Id/inclusion"
        $Emails_ToAdd = @()
        $null = $APIToken # https://github.com/PowerShell/PSScriptAnalyzer/issues/1472
    }

    process {
        if ($PSCmdlet.ShouldProcess($Email, 'Add SSO inclusion')) {
            $Emails_ToAdd += $Email
        }

        if ($Emails_ToAdd.Length -eq 100) {
            Invoke-TeamViewerJsonRestMethod `
                -APIToken $APIToken `
                -Uri $Resource_Uri `
                -Method Post `
                -Body (@{ emails = @($Emails_ToAdd) } | ConvertTo-Json) `
                -CallerCmdlet $PSCmdlet | Out-Null
            $Emails_ToAdd = @()
        }
    }
    end {
        if ($Emails_ToAdd.Length -gt 0) {
            Invoke-TeamViewerJsonRestMethod `
                -APIToken $APIToken `
                -Uri $Resource_Uri `
                -Method Post `
                -Body (@{ emails = @($Emails_ToAdd) } | ConvertTo-Json) `
                -CallerCmdlet $PSCmdlet | Out-Null
        }
    }
}
