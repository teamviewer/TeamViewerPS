function Get-TeamViewerVersion {
    if (Test-TeamViewerInstallation) {
        switch (Get-OperatingSystem) {
            'Windows' {
                return (Get-ItemPropertyValue -Path (Get-TeamViewerRegKeyPath) -Name 'Version')
            }
            'Linux' {
                return (Get-TeamViewerLinuxGlobalConfig -Name 'Version')
            }
        }
    }
}
