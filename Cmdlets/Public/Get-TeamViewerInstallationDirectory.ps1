function Get-TeamViewerInstallationDirectory {
    switch (Get-OperatingSystem) {
        'Windows' {
            $regKey = Get-TeamViewerRegKeyPath
            $installationDirectory = if (Test-Path $regKey) {
 (Get-Item $regKey).GetValue('InstallationDirectory')
            }
            if (
                $installationDirectory -And `
                (Test-Path "$installationDirectory/TeamViewer.exe")
            ) {
                return $installationDirectory
            }
        }
        'Linux' {
            if (
                (Test-Path '/opt/teamviewer/tv_bin/TeamViewer')
            ) {
                return '/opt/teamviewer/tv_bin/'
            }
        }
        default {
            Write-Error 'TeamViewer not installed'
        }
    }
}

