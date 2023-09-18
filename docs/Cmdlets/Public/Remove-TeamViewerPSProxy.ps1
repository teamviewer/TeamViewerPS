function Remove-TeamViewerPSProxy {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param()
    
    $global:TeamViewerProxyUriSet = $null
    $global:TeamViewerProxyUriSet | Out-Null  # https://github.com/PowerShell/PSScriptAnalyzer/issues/1472
    $global:TeamViewerProxyUriRemoved = $true
    $global:TeamViewerProxyUriRemoved | Out-Null  # https://github.com/PowerShell/PSScriptAnalyzer/issues/1472

    [Environment]::SetEnvironmentVariable('TeamViewerProxyUri','', 'User')
}
