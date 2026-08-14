function Get-TeamViewerVersion {
    [CmdletBinding()]

    param()

    if (Test-TeamViewerInstallation) {
        return (Get-ItemPropertyValue -Path (Get-TeamViewerRegKeyPath) -Name 'Version')
    }
}
