function Get-TeamViewerService {
    if (Test-TeamViewerInstallation) {
        Get-Service -Name 'TeamViewer'
    }
    else {
        return $null
    }
}
