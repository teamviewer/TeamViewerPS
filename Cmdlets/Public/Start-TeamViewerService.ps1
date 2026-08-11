function Start-TeamViewerService {
    [CmdletBinding(SupportsShouldProcess = $true)]

    param()

    if (Test-TeamViewerInstallation) {
        if ($PSCmdlet.ShouldProcess('TeamViewer service')) {
            Start-Service -Name 'TeamViewer'
        }    
    }
    else {
        return $null
    }
}
