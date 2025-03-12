function Remove-TeamViewerSsoInclusion {
    [CmdletBinding(SupportsShouldProcess = $true)]
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
    Begin {
        $id = $DomainId | Resolve-TeamViewerSsoDomainId
        $resourceUri = "$(Get-TeamViewerApiUri)/ssoDomain/$id/inclusion"
        $emailsToRemove = @()
        $null = $ApiToken   # https://github.com/PowerShell/PSScriptAnalyzer/issues/1472

        function Invoke-RequestInternal {
            $body = @{
                emails = @($emailsToRemove)
            }
            Invoke-TeamViewerRestMethod `
                -ApiToken $ApiToken `
                -Uri $resourceUri `
                -Method Delete `
                -ContentType 'application/json; charset=utf-8' `
                -Body ([System.Text.Encoding]::UTF8.GetBytes(($body | ConvertTo-Json))) `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop | `
                Out-Null
        }
    }
    Process {
        if ($PSCmdlet.ShouldProcess($Email, 'Remove SSO inclusion')) {
            $emailsToRemove += $Email
        }
        if ($emailsToRemove.Length -eq 100) {
            Invoke-RequestInternal
            $emailsToRemove = @()
        }
    }
    End {
        if ($emailsToRemove.Length -gt 0) {
            Invoke-RequestInternal
        }
    }
}
