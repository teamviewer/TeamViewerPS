function Add-TeamViewerSsoInclusion {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerSsoDomainId } )]
        [Alias("Domain")]
        [object]
        $DomainId,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string[]]
        $Email
    )
    Begin {
        $id = $DomainId | Resolve-TeamViewerSsoDomainId
        $resourceUri = "$(Get-TeamViewerApiUri)/ssoDomain/$id/inclusion"
        $emailsToAdd = @()
		$null = $ApiToken

        function Invoke-RequestInternal {
            $body = @{
                emails = @($emailsToAdd)
            }
			Invoke-TeamViewerRestMethod `
				-ApiToken $ApiToken `
                -Uri $resourceUri `
                -Method Post `
                -ContentType "application/json; charset=utf-8" `
                -Body ([System.Text.Encoding]::UTF8.GetBytes(($body | ConvertTo-Json))) `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop | `
                Out-Null
        }
    }
    Process {
        if ($PSCmdlet.ShouldProcess($Email, "Add SSO inclusion")) {
            $emailsToAdd += $Email
        }
        if ($emailsToAdd.Length -eq 100) {
            Invoke-RequestInternal
            $emailsToAdd = @()
        }
    }
    End {
        if ($emailsToAdd.Length -gt 0) {
            Invoke-RequestInternal
        }
    }
}