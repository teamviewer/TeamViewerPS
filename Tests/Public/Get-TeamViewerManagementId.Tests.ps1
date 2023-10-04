BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Get-TeamViewerManagementId.ps1"

    . "$PSScriptRoot\..\..\Cmdlets\Public\Test-TeamViewerInstallation.ps1"
    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | `
        ForEach-Object { . $_.FullName }
    $testManagementId = New-Guid
    $null = $testManagementId
}

Describe 'Get-TeamViewerManagementId' {
    Context 'Windows' {
        BeforeAll {
            function Get-TestItemValue([object]$obj) {
            }
            Mock Get-TestItemValue `
                -ParameterFilter { $obj -eq 'Unmanaged' } { }
            Mock Get-TestItemValue `
                -ParameterFilter { $obj -eq 'ManagementId' } { $testManagementId.ToString('B') }
            $testItem = [PSCustomObject]@{}
            $testItem | Add-Member `
                -MemberType ScriptMethod `
                -Name GetValue `
                -Value { param($obj) Get-TestItemValue @PSBoundParameters }
            Mock Get-OperatingSystem { 'Windows' }
            Mock Get-TeamViewerRegKeyPath { 'testRegistry' }
            Mock Get-Item { $testItem }
            Mock Test-Path { $true }
            Mock Test-TeamViewerInstallation { $true }
        }

        It 'Should return the Management ID from the Windows Registry' {
            Get-TeamViewerManagementId | Should -Be $testManagementId
            Assert-MockCalled Test-TeamViewerInstallation -Scope It -Times 1
            Assert-MockCalled Get-OperatingSystem -Scope It -Times 1
            Assert-MockCalled Get-TeamViewerRegKeyPath -Scope It -Times 1
            Assert-MockCalled Test-Path -Scope It -Times 1 -ParameterFilter {
                $LiteralPath -eq (Join-Path 'testRegistry' 'DeviceManagementV2')
            }
            Assert-MockCalled Get-Item -Scope It -Times 1 -ParameterFilter {
                $Path -eq (Join-Path 'testRegistry' 'DeviceManagementV2')
            }
            Assert-MockCalled Get-TestItemValue -Scope It -Times 1 -ParameterFilter {
                $obj -eq 'Unmanaged'
            }
            Assert-MockCalled Get-TestItemValue -Scope It -Times 1 -ParameterFilter {
                $obj -eq 'ManagementId'
            }
        }

        It 'Should return nothing when TeamViewer is not installed' {
            Mock Test-TeamViewerInstallation { $false }
            Get-TeamViewerManagementId | Should -BeNullOrEmpty
        }

        It 'Should return nothing when registry path does not exist' {
            Mock Test-Path { $false }
            Get-TeamViewerManagementId | Should -BeNullOrEmpty
        }

        It 'Should return nothing when registry item does not exist' {
            Mock Get-Item { }
            Get-TeamViewerManagementId | Should -BeNullOrEmpty
        }

        It 'Should return nothing when the device is marked as unmanaged' {
            Mock Get-TestItemValue -ParameterFilter { $obj -eq 'Unmanaged' } { 1 }
            Get-TeamViewerManagementId | Should -BeNullOrEmpty
        }
    }

    Context 'Linux' {
        BeforeAll {
            Mock Get-OperatingSystem { 'Linux' }
            Mock Test-TeamViewerInstallation { $true }
            Mock Get-TeamViewerLinuxGlobalConfig `
                -ParameterFilter { $Name -eq 'DeviceManagementV2\Unmanaged' } `
                -MockWith { }
            Mock Get-TeamViewerLinuxGlobalConfig `
                -ParameterFilter { $Name -eq 'DeviceManagementV2\ManagementId' } `
                -MockWith { $testManagementId.ToString('B') }
        }

        It 'Should return the Management ID from the global configuration' {
            Get-TeamViewerManagementId | Should -Be $testManagementId
            Assert-MockCalled Test-TeamViewerInstallation -Scope It -Times 1
            Assert-MockCalled Get-OperatingSystem -Scope It -Times 1
        }

        It 'Should return nothing when TeamViewer is not installed' {
            Mock Test-TeamViewerInstallation { $false }
            Get-TeamViewerManagementId | Should -BeNullOrEmpty
        }

        It 'Should return nothing when the device is marked as unmanaged' {
            Mock Get-TeamViewerLinuxGlobalConfig `
                -ParameterFilter { $Name -eq 'DeviceManagementV2\Unmanaged' } `
                -MockWith { 1 }
            Get-TeamViewerManagementId | Should -BeNullOrEmpty
        }
    }
}
