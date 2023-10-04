function Get-TeamViewerLogFilePath {
    param(
        [switch]
        $OpenFile
    )

    if (Test-TeamViewerInstallation) {
        if (Get-OperatingSystem -eq 'Windows') {
            $SearchDirectories = Get-TSCSearchDirectory
            $LogFiles = New-Object System.Collections.ArrayList
            foreach ($Name in $SearchDirectories.Keys) {
                $SearchDirectory = $SearchDirectories[$Name]
                foreach ($Folder in $SearchDirectory) {
                    if (Test-Path -Path $Folder) {
                        $files = Get-ChildItem -Path $Folder -File -Recurse
                        foreach ($file in $files) {
                            if ($file.Name.EndsWith('.log')) {
                                $LogFiles.add($file.FullName) | Out-Null
                            }
                        }
                    }
                }
            }

            if ($OpenFile) {
                $LogFile = $host.ui.PromptForChoice('Select file', 'Choose file:', `
                    @($LogFiles), 0)
                Invoke-Item -Path $LogFiles[$LogFile]
            }
            else {
                return $LogFiles
            }
        }
    }
    else {
        Write-Error 'TeamViewer is not installed.'
    }
}
