function Get-TeamViewerVersion {
    if (Test-TeamViewerInstallation) {
        return (Get-ItemPropertyValue -Path (Get-TeamViewerRegKeyPath) -Name 'Version')
    }
}
