function Get-TeamViewerInstallationPackage {
    if (Test-TeamViewerInstallation) {
        $Package = (Get-Item -Path (Join-Path -Path $TV_InstallationDirectory -ChildPath 'TeamViewer.exe')).VersionInfo.ProductName

        switch -Wildcard ($Package) {
            '*Full*' {
                return 'Full'
            }
            '*Host*' {
                return 'Host'
            }
            default {
                return $null
            }
        }
    }
    else {
        return $null
    }
}
