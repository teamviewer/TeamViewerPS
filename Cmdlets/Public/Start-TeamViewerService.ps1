function Start-TeamViewerService {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param()

    if ($PSCmdlet.ShouldProcess("TeamViewer service")) {
        switch (Get-OperatingSystem) {
            'Windows' {
                Start-Service -Name (Get-TeamViewerServiceName)
            }
            'Linux' {
                Invoke-ExternalCommand /opt/teamviewer/tv_bin/script/teamviewer daemon start
            }
        }
    }
}
