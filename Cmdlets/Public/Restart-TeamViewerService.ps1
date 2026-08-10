function Restart-TeamViewerService {
    [CmdletBinding(SupportsShouldProcess = $true)]

    param()

    if (Test-TeamViewerInstallation) {
        if ($PSCmdlet.ShouldProcess('TeamViewer service')) {
            Restart-Service -Name 'TeamViewer'
        }
    }
    else {
        return $null
    }
}
