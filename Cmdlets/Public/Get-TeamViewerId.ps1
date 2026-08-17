function Get-TeamViewerId {
    [CmdletBinding()]

    [OutputType([string])]

    param()

    if (Test-TeamViewerInstallation) {
        Write-Output (Get-ItemPropertyValue -Path (Get-TeamViewerRegKeyPath) -Name 'ClientID')
    }
}
