function Get-TeamViewerId {
    if (Test-TeamViewerInstallation) {
        Write-Output (Get-ItemPropertyValue -Path (Get-TeamViewerRegKeyPath) -Name 'ClientID')
    }
}
