function Get-TeamViewerVersion {
    [CmdletBinding()]

    [OutputType([string])]

    param()

    if (Test-TeamViewerInstallation) {
        return (Get-ItemPropertyValue -Path (Get-TeamViewerRegKeyPath) -Name 'Version')
    }
}
