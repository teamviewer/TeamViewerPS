BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Get-TeamViewerInstallationType.ps1"
    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }
}

Describe 'Get-TeamViewerInstallationType' {
    Context 'MsiInstallation - both database and registry present' {
        BeforeAll {
            Mock Test-Path { $true }
            Mock Get-ChildItem {
                $RegistryKey = New-Object PSObject
                $RegistryKey | Add-Member -MemberType NoteProperty -Name 'PSPath' -Value 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\TeamViewer'
                $RegistryKey | Add-Member -MemberType ScriptMethod -Name 'GetValue' -Value { return 'TeamViewer' }
                $RegistryKey
            }
            Mock Get-ItemProperty {
                [PSCustomObject]@{ WindowsInstaller = 1 }
            } -ParameterFilter { $Name -eq 'WindowsInstaller' }
            Mock Get-ItemProperty {
                [PSCustomObject]@{ MsiInstallation = 1 }
            } -ParameterFilter { $Name -eq 'MsiInstallation' }
        }

        It 'Should return MSI when MSI database and MsiInstallation registry value are both present' {
            $Result = Get-TeamViewerInstallationType
            $Result | Should -Be 'MSI'
        }
    }

    Context 'MSI database found but no registry value' {
        BeforeAll {
            Mock Test-Path { $true }
            Mock Get-ChildItem {
                $RegistryKey = New-Object PSObject
                $RegistryKey | Add-Member -MemberType NoteProperty -Name 'PSPath' -Value 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\TeamViewer'
                $RegistryKey | Add-Member -MemberType ScriptMethod -Name 'GetValue' -Value { return 'TeamViewer' }
                $RegistryKey
            }
            Mock Get-ItemProperty {
                throw [System.Management.Automation.ItemNotFoundException]::new()
            } -ParameterFilter { $Name -eq 'MsiInstallation' }
            Mock Get-ItemProperty {
                [PSCustomObject]@{ WindowsInstaller = 1 }
            } -ParameterFilter { $Name -eq 'WindowsInstaller' }
        }

        It 'Should not return MSI if only database entry exists' {
            $Result = Get-TeamViewerInstallationType
            $Result | Should -Not -Be 'MSI'
        }
    }

    Context 'Registry value found but no MSI database entry' {
        BeforeAll {
            Mock Test-Path { $true }
            Mock Get-ChildItem {
                $RegistryKey = New-Object PSObject
                $RegistryKey | Add-Member -MemberType NoteProperty -Name 'PSPath' -Value 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\TeamViewer'
                $RegistryKey | Add-Member -MemberType ScriptMethod -Name 'GetValue' -Value { return 'TeamViewer' }
                $RegistryKey
            }
            Mock Get-ItemProperty {
                [PSCustomObject]@{ MsiInstallation = 1 }
            } -ParameterFilter { $Name -eq 'MsiInstallation' }
            Mock Get-ItemProperty {
                throw [System.Management.Automation.ItemNotFoundException]::new()
            } -ParameterFilter { $Name -eq 'WindowsInstaller' }
        }

        It 'Should not return MSI if only registry value exists' {
            $Result = Get-TeamViewerInstallationType
            $Result | Should -Not -Be 'MSI'
        }
    }

    Context 'exeInstallation with valid UninstallString' {
        BeforeAll {
            Mock Get-CimInstance {
                throw [System.Management.Automation.ItemNotFoundException]::new()
            }

            Mock Get-ItemProperty {
                throw [System.Management.Automation.ItemNotFoundException]::new()
            } -ParameterFilter { $Name -eq 'MsiInstallation' }

            Mock Test-Path { $true }
            Mock Get-ChildItem {
                $registryKey = New-Object PSObject
                $registryKey | Add-Member -MemberType NoteProperty -Name 'Name' -Value 'TeamViewer'
                $registryKey | Add-Member -MemberType NoteProperty -Name 'PSPath' -Value 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\TeamViewer'
                $registryKey | Add-Member -MemberType ScriptMethod -Name 'GetValue' -Value { return 'TeamViewer' }
                $registryKey
            }

            Mock Get-ItemProperty {
                [PSCustomObject]@{
                    UninstallString = '"C:\Program Files\TeamViewer\uninstall.exe" /S'
                }
            } -ParameterFilter { $Name -eq 'UninstallString' }
        }

        It 'Should return exe when UninstallString file exists' {
            $Result = Get-TeamViewerInstallationType
            $Result | Should -Be 'exe'
        }
    }

    Context 'Broken exeInstallation with missing UninstallString file' {
        BeforeAll {
            Mock Get-CimInstance {
                throw [System.Management.Automation.ItemNotFoundException]::new()
            }

            Mock Get-ItemProperty {
                throw [System.Management.Automation.ItemNotFoundException]::new()
            } -ParameterFilter { $Name -eq 'MsiInstallation' }

            Mock Get-ChildItem {
                $registryKey = New-Object PSObject
                $registryKey | Add-Member -MemberType NoteProperty -Name 'Name' -Value 'TeamViewer'
                $registryKey | Add-Member -MemberType NoteProperty -Name 'PSPath' -Value 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\TeamViewer'
                $registryKey | Add-Member -MemberType ScriptMethod -Name 'GetValue' -Value { return 'TeamViewer' }
                $registryKey
            }

            Mock Get-ItemProperty {
                [PSCustomObject]@{
                    UninstallString = '"C:\Program Files\TeamViewer\uninstall.exe" /S'
                }
            } -ParameterFilter { $Name -eq 'UninstallString' }

            Mock Test-Path {
                param($Path)
                if ($Path -like '*:\Software\*' -or $Path -like '*:\HKEY_*') {
                    return $true
                }
                #file does not exist
                return $false
            }
        }

        It 'Should return Unknown when UninstallString file does not exist' {
            $Result = Get-TeamViewerInstallationType
            $Result | Should -Be 'Unknown'
        }
    }

    Context 'TeamViewer not installed' {
        BeforeAll {
            Mock Get-CimInstance {
                throw [System.Management.Automation.ItemNotFoundException]::new()
            }

            Mock Get-ItemProperty {
                throw [System.Management.Automation.ItemNotFoundException]::new()
            }

            Mock Get-ChildItem { }
            Mock Test-Path { $false }
        }

        It 'Should return Unknown when TeamViewer is not installed' {
            $Result = Get-TeamViewerInstallationType
            $Result | Should -Be 'Unknown'
        }
    }

    Context 'Check both 32-bit and 64-bit registry paths for MSI' {
        BeforeAll {
            Mock Test-Path { $true }
            Mock Get-ChildItem {
                $RegistryKey = New-Object PSObject
                $RegistryKey | Add-Member -MemberType NoteProperty -Name 'PSPath' -Value 'HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\TeamViewer'
                $RegistryKey | Add-Member -MemberType ScriptMethod -Name 'GetValue' -Value { return 'TeamViewer' }
                $RegistryKey
            }

            Mock Get-ItemProperty {
                [PSCustomObject]@{ WindowsInstaller = 1 }
            } -ParameterFilter { $Name -eq 'WindowsInstaller' }

            Mock Get-ItemProperty {
                param($Path)
                if ($Path -like '*WOW6432Node*') {
                    [PSCustomObject]@{ MsiInstallation = 1 }
                }
                else {
                    throw [System.Management.Automation.ItemNotFoundException]::new()
                }
            } -ParameterFilter { $Name -eq 'MsiInstallation' }
        }

        It 'Should check both registry paths and return MSI if found in WOW6432Node' {
            $Result = Get-TeamViewerInstallationType
            $Result | Should -Be 'MSI'
        }
    }

    Context 'Check both uninstall registry paths for exe' {
        BeforeAll {
            Mock Get-CimInstance {
                throw [System.Management.Automation.ItemNotFoundException]::new()
            }

            Mock Get-ItemProperty {
                throw [System.Management.Automation.ItemNotFoundException]::new()
            } -ParameterFilter { $Name -eq 'MsiInstallation' }

            Mock Get-ItemProperty {
                [PSCustomObject]@{
                    UninstallString = 'C:\Program Files (x86)\TeamViewer\uninstall.exe /quiet'
                }
            } -ParameterFilter { $Name -eq 'UninstallString' }

            Mock Get-ChildItem {
                $registryKey = New-Object PSObject
                $registryKey | Add-Member -MemberType NoteProperty -Name 'Name' -Value 'TeamViewer'
                $registryKey | Add-Member -MemberType NoteProperty -Name 'PSPath' -Value 'HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\TeamViewer'
                $registryKey | Add-Member -MemberType ScriptMethod -Name 'GetValue' -Value { return 'TeamViewer' }
                $registryKey
            }

            Mock Test-Path { $true }
        }

        It 'Should check both 64-bit and 32-bit uninstall paths and return exe' {
            $Result = Get-TeamViewerInstallationType
            $Result | Should -Be 'exe'
        }
    }

    Context 'Multiple TeamViewer uninstall entries' {
        BeforeAll {
            Mock Get-ItemProperty {
                throw [System.Management.Automation.ItemNotFoundException]::new()
            } -ParameterFilter { $Name -eq 'MsiInstallation' }

            Mock Get-ChildItem {
                $InvalidRegistryKey = New-Object PSObject
                $InvalidRegistryKey | Add-Member -MemberType NoteProperty -Name 'PSPath' -Value 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\TeamViewerOld'
                $InvalidRegistryKey | Add-Member -MemberType ScriptMethod -Name 'GetValue' -Value { return 'TeamViewer Old' }

                $ValidRegistryKey = New-Object PSObject
                $ValidRegistryKey | Add-Member -MemberType NoteProperty -Name 'PSPath' -Value 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\TeamViewer'
                $ValidRegistryKey | Add-Member -MemberType ScriptMethod -Name 'GetValue' -Value { return 'TeamViewer' }

                $InvalidRegistryKey
                $ValidRegistryKey
            }

            Mock Get-ItemProperty {
                [PSCustomObject]@{
                    UninstallString = 'C:\Program Files\TeamViewer\uninstall-old.exe'
                }
            } -ParameterFilter { $Name -eq 'UninstallString' -and $Path -like '*TeamViewerOld' }

            Mock Get-ItemProperty {
                [PSCustomObject]@{
                    UninstallString = 'C:\Program Files\TeamViewer\uninstall.exe'
                }
            } -ParameterFilter { $Name -eq 'UninstallString' -and $Path -like '*TeamViewer' }

            Mock Test-Path {
                param($Path)
                if ($Path -like '*uninstall-old.exe') {
                    return $false
                }
                return $true
            }
        }

        It 'Should continue until a valid executable is found' {
            $Result = Get-TeamViewerInstallationType
            $Result | Should -Be 'exe'
        }
    }

    Context 'MSI installation with MSIInstallation value of 0' {
        BeforeAll {
            Mock Get-CimInstance {
                throw [System.Management.Automation.ItemNotFoundException]::new()
            }

            Mock Get-ItemProperty {
                [PSCustomObject]@{ MsiInstallation = 0 }
            } -ParameterFilter { $Name -eq 'MsiInstallation' }

            Mock Get-ChildItem {
                $registryKey = New-Object PSObject
                $registryKey | Add-Member -MemberType NoteProperty -Name 'Name' -Value 'TeamViewer'
                $registryKey | Add-Member -MemberType NoteProperty -Name 'PSPath' -Value 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\TeamViewer'
                $registryKey | Add-Member -MemberType ScriptMethod -Name 'GetValue' -Value { return 'TeamViewer' }
                $registryKey
            }

            Mock Get-ItemProperty {
                [PSCustomObject]@{
                    UninstallString = 'C:\Program Files\TeamViewer\uninstall.exe'
                }
            } -ParameterFilter { $Name -eq 'UninstallString' }

            Mock Test-Path { $true }
        }

        It 'Should return exe when MsiInstallation is 0 (exeInstallation)' {
            $Result = Get-TeamViewerInstallationType
            $Result | Should -Be 'exe'
        }
    }
}
