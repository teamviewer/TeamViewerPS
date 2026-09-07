function Remove-TeamViewerSSOExclusion {
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
        $Resource_Uri = "$(Get-TeamViewerAPIUri)/ssoDomain/$Id/exclusion"
        $EmailsToRemove = @()
        $null = $APIToken # https://github.com/PowerShell/PSScriptAnalyzer/issues/1472

        function Invoke-TeamViewerRestMethodInternal {
            $Body = @{
                emails = @($EmailsToRemove)
            }
            Invoke-TeamViewerRestMethod `
                -APIToken $APIToken `
                -Uri $Resource_Uri `
                -Method Delete `
                -ContentType 'application/json; charset=utf-8' `
                -Body ([System.Text.Encoding]::UTF8.GetBytes(($Body | ConvertTo-Json))) `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop | `
                Out-Null
        }
    }

    process {
        if ($PSCmdlet.ShouldProcess($Email, 'Remove SSO exclusion')) {
            $EmailsToRemove += $Email
        }
        if ($EmailsToRemove.Length -eq 100) {
            Invoke-TeamViewerRestMethodInternal
            $EmailsToRemove = @()
        }
    }

    end {
        if ($EmailsToRemove.Length -gt 0) {
            Invoke-TeamViewerRestMethodInternal
        }
    }
}
