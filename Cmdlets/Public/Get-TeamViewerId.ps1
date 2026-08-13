function Get-TeamViewerId {
    [CmdletBinding()]

    param()

    if (Test-TeamViewerInstallation) {
        Write-Output (Get-ItemPropertyValue -Path (Get-TeamViewerRegKeyPath) -Name 'ClientID')
    }
}
