function Remove-TeamViewerSsoExclusion {
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
        $resourceUri = "$(Get-TeamViewerApiUri)/ssoDomain/$id/exclusion"
        $emailsToRemove = @()
    }
    Process {
        if ($PSCmdlet.ShouldProcess($Email, "Remove SSO exclusion")) {
            $emailsToRemove += $Email
        }
    }
    End {
        $body = @{
            emails = @($emailsToRemove)
        }

        if ($emailsToRemove.Length -gt 0) {
            Invoke-TeamViewerRestMethod `
                -ApiToken $ApiToken `
                -Uri $resourceUri `
                -Method Delete `
                -ContentType "application/json; charset=utf-8" `
                -Body ([System.Text.Encoding]::UTF8.GetBytes(($body | ConvertTo-Json))) `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop | `
                Out-Null
        }
    }
}
