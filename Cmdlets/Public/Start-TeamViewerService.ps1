function Start-TeamViewerService {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param()

    if ($PSCmdlet.ShouldProcess("TeamViewer service")) {
        Start-Service -Name (Get-TeamViewerServiceName)
    }
}
