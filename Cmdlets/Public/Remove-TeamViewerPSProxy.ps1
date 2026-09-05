function Remove-TeamViewerPSProxy {
    [CmdletBinding(SupportsShouldProcess = $true)]

    [OutputType([void])]

    param()

    if ($PSCmdlet.ShouldProcess('TeamViewerPS_ProxyUri', 'Remove proxy for web API')) {
        $global:TeamViewerPS_ProxyUri = $null
        $global:TeamViewerPS_ProxyUri | Out-Null  # https://github.com/PowerShell/PSScriptAnalyzer/issues/1472

        [Environment]::SetEnvironmentVariable('TeamViewerPS_ProxyUri', $null, 'Process')
        [Environment]::SetEnvironmentVariable('TeamViewerPS_ProxyUri', $null, 'User')
    }
}
