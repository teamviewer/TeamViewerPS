function Test-TeamViewer32on64 {
    if (![Environment]::Is64BitOperatingSystem) {
        return $false
    }
    $registryKey = Get-TeamViewerRegKeyPath -Variant WOW6432
    if (!(Test-Path $registryKey)) {
        return $false
    }
    try {
        $installationDirectory = (Get-Item $registryKey).GetValue('InstallationDirectory')
        $binaryPath = Join-Path $installationDirectory 'TeamViewer.exe'
        return Test-Path $binaryPath
    }
    catch {
        return $false
    }
}
