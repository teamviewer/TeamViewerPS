function Get-TeamViewerService {
    Get-Service -Name (Get-TeamViewerServiceName)
}
