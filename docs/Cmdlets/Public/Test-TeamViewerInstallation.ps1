function Test-TeamViewerInstallation {
    if (Get-TeamViewerInstallationDirectory) {
        return $true
    }
    else {
        return $false
    }
}
