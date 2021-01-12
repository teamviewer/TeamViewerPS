function Get-TeamViewerVersion {
    if (Test-TeamViewerInstallation) {
        switch (Get-OperatingSystem) {
            'Windows' {
                Write-Output (Get-ItemPropertyValue -Path (Get-TeamViewerRegKeyPath) -Name 'Version')
            }
            'Linux' {
                Write-Output (Get-TeamViewerLinuxGlobalConfig -Name 'Version')
            }
        }
    }
}
