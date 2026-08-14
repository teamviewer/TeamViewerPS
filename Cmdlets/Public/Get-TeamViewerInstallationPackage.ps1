function Get-TeamViewerInstallationPackage {
    if (Test-TeamViewerInstallation) {
        $TV_InstallationDirectory = Get-TeamViewerInstallationDirectory

        try {
            $Package = (Get-Item -Path (Join-Path -Path $TV_InstallationDirectory -ChildPath 'TeamViewer.exe')).VersionInfo.ProductName
        }
        catch {
            Write-Verbose "Failed to read the TeamViewer file attribute information: $($_.Exception.Message)"

            return $null
        }

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
        Write-Verbose 'TeamViewer is not installed!'

        return $null
    }
}
