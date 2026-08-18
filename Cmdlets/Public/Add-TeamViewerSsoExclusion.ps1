function Add-TeamViewerSsoExclusion {
    [CmdletBinding(SupportsShouldProcess = $true)]

    [OutputType([void])]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerSsoDomainId } )]
        [Alias('Domain')]
        [object]
        $DomainId,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string[]]
        $Email
    )

    begin {
        $Id = $DomainId | Resolve-TeamViewerSsoDomainId
        $ResourceUri = "$(Get-TeamViewerApiUri)/ssoDomain/$Id/exclusion"
        $EmailsToAdd = @()
        $null = $ApiToken   # https://github.com/PowerShell/PSScriptAnalyzer/issues/1472

        function Invoke-RequestInternal {
            $Body = @{
                emails = @($EmailsToAdd)
            }

            Invoke-TeamViewerRestMethod `
                -ApiToken $ApiToken `
                -Uri $ResourceUri `
                -Method Post `
                -ContentType 'application/json; charset=utf-8' `
                -Body ([System.Text.Encoding]::UTF8.GetBytes(($Body | ConvertTo-Json))) `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop | `
                Out-Null
        }
    }

    process {
        if ($PSCmdlet.ShouldProcess($Email, 'Add SSO exclusion')) {
            $EmailsToAdd += $Email
        }
        if ($EmailsToAdd.Length -eq 100) {
            Invoke-RequestInternal
            $EmailsToAdd = @()
        }
    }

    end {
        if ($EmailsToAdd.Length -gt 0) {
            Invoke-RequestInternal
        }
    }
}
