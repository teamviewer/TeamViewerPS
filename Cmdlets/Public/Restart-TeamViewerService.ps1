function Restart-TeamViewerService {
    [CmdletBinding(SupportsShouldProcess = $true)]

    [OutputType([void])]

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
