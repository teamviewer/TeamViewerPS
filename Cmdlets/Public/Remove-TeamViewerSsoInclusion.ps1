function Remove-TeamViewerSSOInclusion {
    [CmdletBinding(SupportsShouldProcess = $true)]

    [OutputType([void])]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $APIToken,

        [Parameter(Mandatory = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerSSODomainId } )]
        [Alias('Id', 'Domain', 'SSODomainId', 'SSODomain')]
        [object]
        $DomainId,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [Alias('EmailAddress')]
        [string[]]
        $Email
    )

    begin {
        $Id = $DomainId | Resolve-TeamViewerSSODomainId
        $Resource_Uri = "$(Get-TeamViewerAPIUri)/ssoDomain/$Id/inclusion"
        $EmailsToRemove = @()
        $null = $APIToken # https://github.com/PowerShell/PSScriptAnalyzer/issues/1472
    }

    process {
        if ($PSCmdlet.ShouldProcess($Email, 'Remove SSO inclusion')) {
            $EmailsToRemove += $Email
        }

        if ($EmailsToRemove.Length -eq 100) {
            Invoke-TeamViewerJsonRestMethod `
                -APIToken $APIToken `
                -Uri $Resource_Uri `
                -Method Delete `
                -Body (@{ emails = @($EmailsToRemove) } | ConvertTo-Json) `
                -CallerCmdlet $PSCmdlet | Out-Null
            $EmailsToRemove = @()
        }
    }

    end {
        if ($EmailsToRemove.Length -gt 0) {
            Invoke-TeamViewerJsonRestMethod `
                -APIToken $APIToken `
                -Uri $Resource_Uri `
                -Method Delete `
                -Body (@{ emails = @($EmailsToRemove) } | ConvertTo-Json) `
                -CallerCmdlet $PSCmdlet | Out-Null
        }
    }
}
