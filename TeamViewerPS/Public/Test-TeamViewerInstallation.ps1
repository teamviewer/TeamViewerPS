function Test-TeamViewerInstallation {
    switch (Get-OperatingSystem) {
        'Windows' {
            $regKey = Get-TeamViewerRegKeyPath
            $installationDirectory = if (Test-Path $regKey) { (Get-Item $regKey).GetValue('InstallationDirectory') }
            Write-Output (
                $installationDirectory -And `
                (Test-Path "$installationDirectory/TeamViewer.exe")
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
