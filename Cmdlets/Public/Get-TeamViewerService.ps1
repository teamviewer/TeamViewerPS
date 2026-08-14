function Get-TeamViewerService {
    [CmdletBinding()]

    param()

    if (Test-TeamViewerInstallation) {
        Get-Service -Name 'TeamViewer'
    }
    else {
        return $null
    }
}
