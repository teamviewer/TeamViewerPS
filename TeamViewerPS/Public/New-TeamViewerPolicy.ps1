function New-TeamViewerPolicy {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true)]
        [string]
        $Name,

        [Parameter()]
        [AllowEmptyCollection()]
        [object[]]
        $Settings,

        [Parameter()]
        [switch]
        $DefaultPolicy = $False
    )

    $body = @{
        name     = $Name
        default  = [boolean]$DefaultPolicy
        settings = @()
    }

    if ($Settings) {
        $body.settings = @($Settings)
    }

    $resourceUri = "$(Get-TeamViewerApiUri)/teamviewerpolicies"
    if ($PSCmdlet.ShouldProcess($Name, "Create policy")) {
        Invoke-TeamViewerRestMethod `
            -ApiToken $ApiToken `
            -Uri $resourceUri `
            -Method Post `
            -ContentType "application/json; charset=utf-8" `
            -Body ([System.Text.Encoding]::UTF8.GetBytes(($body | ConvertTo-Json))) `
            -WriteErrorTo $PSCmdlet | `
            Out-Null
    }
}
