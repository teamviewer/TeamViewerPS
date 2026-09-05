$global:TeamViewerPS_ProxyUri = $null

function Set-TeamViewerPSProxy {
    [CmdletBinding(SupportsShouldProcess = $true)]

    [OutputType([string])]

    param (
        [Parameter(Mandatory = $true)]
        [Uri]
        $ProxyUri
    )

    if ($PSCmdlet.ShouldProcess($ProxyUri, 'Sets proxy for web API')) {
        $global:TeamViewerPS_ProxyUri = $ProxyUri

        [Environment]::SetEnvironmentVariable('TeamViewerPS_ProxyUri', $ProxyUri, 'User')
        [Environment]::SetEnvironmentVariable('TeamViewerPS_ProxyUri', $ProxyUri, 'Process')
    }
}
