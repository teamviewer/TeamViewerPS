BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Get-TeamViewerInstallationType.ps1"
    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | `
        ForEach-Object { . $_.FullName }
}

Describe 'Get-TeamViewerInstallationType' {
    Context 'MsiInstallation - both database and registry present' {
        BeforeAll {
            Mock Get-CimInstance { 
                [PSCustomObject]@{ Name = 'TeamViewer' } 
            }
            Mock Get-ItemProperty { 
                [PSCustomObject]@{ MsiInstallation = 1 } 
            }
        }

        It 'Should return MSI when MSI database and MsiInstallation registry value are both present' {
            $result = Get-TeamViewerInstallationType
            $result | Should -Be 'MSI'
            Assert-MockCalled Get-CimInstance -Times 1
        }
    }

    Context 'MSI database found but no registry value' {
        BeforeAll {
            Mock Get-CimInstance { 
                [PSCustomObject]@{ Name = 'TeamViewer' } 
            }
            Mock Get-ItemProperty { 
                throw [System.Management.Automation.ItemNotFoundException]::new()
            }
        }

        It 'Should not return MSI if only database entry exists' {
            $result = Get-TeamViewerInstallationType
            $result | Should -Not -Be 'MSI'
        }
    }

    Context 'Registry value found but no MSI database entry' {
        BeforeAll {
            Mock Get-CimInstance { 
                throw [System.Management.Automation.ItemNotFoundException]::new()
            }
            Mock Get-ItemProperty { 
                [PSCustomObject]@{ MsiInstallation = 1 } 
            }
        }

        It 'Should not return MSI if only registry value exists' {
            $result = Get-TeamViewerInstallationType
            $result | Should -Not -Be 'MSI'
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
            $result = Get-TeamViewerInstallationType
            $result | Should -Be 'exe'
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
            $result = Get-TeamViewerInstallationType
            $result | Should -Be 'Unknown'
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
            $result = Get-TeamViewerInstallationType
            $result | Should -Be 'Unknown'
        }
    }

    Context 'Check both 32-bit and 64-bit registry paths for MSI' {
        BeforeAll {
            Mock Get-CimInstance { 
                [PSCustomObject]@{ Name = 'TeamViewer' } 
            }
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
            $result = Get-TeamViewerInstallationType
            $result | Should -Be 'MSI'
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
            $result = Get-TeamViewerInstallationType
            $result | Should -Be 'exe'
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
            $result = Get-TeamViewerInstallationType
            $result | Should -Be 'exe'
        }
    }
}
