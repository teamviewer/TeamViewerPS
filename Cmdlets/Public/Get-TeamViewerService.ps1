function Get-TeamViewerService {
    [CmdletBinding()]

    [OutputType([void])]

    param()

    if (Test-TeamViewerInstallation) {
        Get-Service -Name 'TeamViewer'
    }
    else {
        return $null
    }
}
