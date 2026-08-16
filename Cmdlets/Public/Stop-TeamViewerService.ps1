function Stop-TeamViewerService {
    [CmdletBinding(SupportsShouldProcess = $true)]

    [OutputType([void])]

    param()

    if (Test-TeamViewerInstallation) {
        if ($PSCmdlet.ShouldProcess('TeamViewer service')) {
            Stop-Service -Name 'TeamViewer'
        }
    }
    else {
        return $null
    }
}
