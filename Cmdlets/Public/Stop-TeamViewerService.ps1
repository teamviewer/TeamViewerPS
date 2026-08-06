function Stop-TeamViewerService {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param()

    if ($PSCmdlet.ShouldProcess("TeamViewer service")) {
        Stop-Service -Name (Get-TeamViewerServiceName)
    }
}
