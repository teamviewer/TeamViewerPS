function Remove-TeamViewerSSOInclusion {
    [CmdletBinding(SupportsShouldProcess = $true)]

    [OutputType([void])]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $APIToken,

        [Parameter(Mandatory = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerSSODomainId } )]
        [Alias('Domain')]
        [object]
        $DomainId,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string[]]
        $Email
    )

    begin {
        $Id = $DomainId | Resolve-TeamViewerSSODomainId
        $ResourceUri = "$(Get-TeamViewerAPIUri)/ssoDomain/$Id/inclusion"
        $EmailsToRemove = @()
        $null = $APIToken   # https://github.com/PowerShell/PSScriptAnalyzer/issues/1472

        function Invoke-RequestInternal {
            $Body = @{
                emails = @($EmailsToRemove)
            }
            Invoke-TeamViewerRestMethod `
                -APIToken $APIToken `
                -Uri $ResourceUri `
                -Method Delete `
                -ContentType 'application/json; charset=utf-8' `
                -Body ([System.Text.Encoding]::UTF8.GetBytes(($Body | ConvertTo-Json))) `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop | `
                Out-Null
        }
    }

    process {
        if ($PSCmdlet.ShouldProcess($Email, 'Remove SSO inclusion')) {
            $EmailsToRemove += $Email
        }

        if ($EmailsToRemove.Length -eq 100) {
            Invoke-RequestInternal
            $EmailsToRemove = @()
        }
    }

    end {
        if ($EmailsToRemove.Length -gt 0) {
            Invoke-RequestInternal
        }
    }
}
