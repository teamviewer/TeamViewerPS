function Get-RegistryPaths {
    param(
        [Parameter(ValueFromPipeline = $true)]
        [string]
        $OutputPath
    )
    Begin {
        $SearchProgramms = @('TeamViewer', 'Blizz', 'TeamViewerMeeting')
        $RegistrySearchPathsLocalMachine = @('SOFTWARE\Wow6432Node', 'SOFTWARE')
        $RegistrySearchPathsCurrentUser = @('SOFTWARE')
        $AllTVRegistryData = New-Object System.Collections.ArrayList
    }

    Process {
        foreach ($searchProgramm in $SearchProgramms) {
            foreach ($registrySearchPath in $RegistrySearchPathsLocalMachine) {
                $regKey = [Microsoft.Win32.Registry]::LocalMachine.OpenSubKey("$registrySearchPath\$searchProgramm", $false)
                if ($regKey) {
                    Add-Registry -RegKey $regKey -Program $searchProgramm
                }
            }

            foreach ($registrySearchPath in $RegistrySearchPathsCurrentUser) {
                $regKey = [Microsoft.Win32.Registry]::CurrentUser.OpenSubKey("$registrySearchPath\$searchProgramm", $false)
                if ($searchProgramm -eq 'Blizz' -or $searchProgramm -eq 'TeamViewerMeeting') {
                    $regKey = [Microsoft.Win32.Registry]::CurrentUser.OpenSubKey("$registrySearchPath\$searchProgramm\MachineFallback", $false)
                }
                if ($regKey) {
                    Add-Registry -RegKey $regKey -Program $searchProgramm
                }
            }

            $output = "Windows Registry Editor Version 5.00 `r`n"
            foreach ($data in $AllTVRegistryData) {
                $output += "[$($data.RegistryPath)]`r`n"
                foreach ($entry in $data.Entries) {
                    if ($null -ne $entry.name) {
                        $output += """$($entry.Name)""" + $entry.Type + $entry.Value + "`r`n"
                    }
                }
                $output += "`r`n"
            }
            $output | Out-File -FilePath "$OutputPath\Data\TeamViewer_Version15\Reg_Version15.txt"
        }
    }

}
