function Test-TeamViewerInstallation {
    switch (Get-OperatingSystem) {
        'Windows' {
            Write-Output (
                (Test-Path (Get-TeamViewerRegKeyPath)) -And `
                (Test-Path "$(Get-ItemPropertyValue -Path (Get-TeamViewerRegKeyPath) -Name 'InstallationDirectory')/TeamViewer.exe")
            )
        }
        'Linux' {
            Write-Output (
                (Test-Path '/opt/teamviewer/tv_bin/TeamViewer')
            )
        }
        default { $false }
    }
}
