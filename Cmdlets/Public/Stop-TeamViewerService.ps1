function Stop-TeamViewerService {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param()

    if ($PSCmdlet.ShouldProcess("TeamViewer service")) {
        switch (Get-OperatingSystem) {
            'Windows' {
                Stop-Service -Name (Get-TeamViewerServiceName)
            }
            'Linux' {
                Invoke-ExternalCommand /opt/teamviewer/tv_bin/script/teamviewer daemon stop
            }
        }
    }
}
