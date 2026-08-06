function Get-TeamViewerInstallationDirectory {
    $regKey = Get-TeamViewerRegKeyPath
    $installationDirectory = if (Test-Path $regKey) {
        (Get-Item $regKey).GetValue('InstallationDirectory')
    }
    if (
        $installationDirectory -And `
        (Test-Path "$installationDirectory/TeamViewer.exe")
    ) {
        return $installationDirectory
    }
}

