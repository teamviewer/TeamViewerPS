function New-TeamViewerPolicy {
    [CmdletBinding(SupportsShouldProcess = $true)]

    [OutputType([void])]

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

    $Body = @{
        name     = $Name
        default  = [boolean]$DefaultPolicy
        settings = @()
    }

    if ($Settings) {
        $Body.settings = @($Settings)
    }

    $ResourceUri = "$(Get-TeamViewerApiUri)/teamviewerpolicies"
    if ($PSCmdlet.ShouldProcess($Name, 'Create policy')) {
        Invoke-TeamViewerRestMethod `
            -ApiToken $ApiToken `
            -Uri $ResourceUri `
            -Method Post `
            -ContentType 'application/json; charset=utf-8' `
            -Body ([System.Text.Encoding]::UTF8.GetBytes(($Body | ConvertTo-Json))) `
            -WriteErrorTo $PSCmdlet | `
            Out-Null
    }
}
