function Get-TSCDirectoryFile {
    param(
        [Parameter(ValueFromPipeline = $true)]
        [string]
        $OutputPath
    )

    Process {
        $SearchDirectories = Get-TSCSearchDirectory
        $TempDirectory = New-Item -Path $OutputPath -Name 'Data' -ItemType Directory -Force
        $Endings = @('.log', 'tvinfo.ini', '.mdmp', 'Connections.txt', 'Connections_incoming.txt')
        $TmpLogFiles = @()
        foreach ($Name in $SearchDirectories.Keys) {
            $SearchDirectory = $SearchDirectories[$Name]
            foreach ($Folder in $SearchDirectory) {
                if (Test-Path -Path $Folder) {
                    $TempSubdirectory = Join-Path -Path $TempDirectory -ChildPath $Name
                    New-Item -Path $TempSubdirectory -ItemType Directory -Force | Out-Null
                    $files = Get-ChildItem -Path $Folder -File -Recurse
                    foreach ($file in $files) {
                        foreach ($ending in $Endings) {
                            if ($file.Name.EndsWith($ending)) {
                                $tmpLogfilePath = Join-Path -Path $TempSubdirectory -ChildPath $file.Name
                                Copy-Item -Path $file.FullName -Destination $tmpLogfilePath -Force
                                $TmpLogFiles += $tmpLogfilePath
                                Write-Output "Collected log file from $($file.FullName)"
                            }
                        }
                    }
                }
            }
        }
        Write-Output 'Files from TeamViewer directories have been collected.'
    }
}
