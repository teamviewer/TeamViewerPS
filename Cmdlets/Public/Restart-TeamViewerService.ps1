function Restart-TeamViewerService {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param()

    if ($PSCmdlet.ShouldProcess('TeamViewer service')) {
        Restart-Service -Name (Get-TeamViewerServiceName)
    }
}
