function Get-TeamViewerId {
    if (Test-TeamViewerInstallation) {
        switch (Get-OperatingSystem) {
            'Windows' {
                Write-Output (Get-ItemPropertyValue -Path (Get-TeamViewerRegKeyPath) -Name 'ClientID')
            }
            'Linux' {
                Write-Output (Get-TeamViewerLinuxGlobalConfig -Name 'ClientID')
            }
        }
    }
}
