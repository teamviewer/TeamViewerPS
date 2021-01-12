function Get-TeamViewerService {
    switch (Get-OperatingSystem) {
        'Windows' {
            Get-Service -Name (Get-TeamViewerServiceName)
        }
        'Linux' {
            Invoke-ExternalCommand /opt/teamviewer/tv_bin/script/teamviewer daemon status
        }
    }
}
