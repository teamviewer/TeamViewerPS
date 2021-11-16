BeforeAll {
    . "$PSScriptRoot/../../TeamViewerPS/Public/Get-TeamViewerId.ps1"

    . "$PSScriptRoot/../../TeamViewerPS/Public/Test-TeamViewerInstallation.ps1"
    @(Get-ChildItem -Path "$PSScriptRoot/../../TeamViewerPS/Private/*.ps1") | `
        ForEach-Object { . $_.FullName }
    Mock Get-ItemPropertyValue { 123456 }
}

Describe 'Get-TeamViewerId' {
    Context 'Windows' {
        BeforeAll {
            Mock Get-TeamViewerRegKeyPath { 'testRegistry' }
            Mock Get-OperatingSystem { 'Windows' }
            Mock Test-TeamViewerInstallation { $true }
        }

        It 'Should return the TeamViewer ID from the Windows Registry' {
            Get-TeamViewerId | Should -Be 123456
            Assert-MockCalled Get-ItemPropertyValue -Scope It -Times 1 -ParameterFilter {
                $Path -Eq 'testRegistry' -And $Name -Eq 'ClientID'
            }
        }
    }

    Context 'Linux' {
        BeforeAll {
            Mock Get-OperatingSystem { 'Linux' }
            Mock Test-TeamViewerInstallation { $true }
            Mock Get-TeamViewerLinuxGlobalConfig { 123456 }
        }

        It 'Should return the TeamViewer ID from the global configuration' {
            Get-TeamViewerId | Should -Be 123456
            Assert-MockCalled Get-TeamViewerLinuxGlobalConfig -Scope It -Times 1 -ParameterFilter {
                $Name -Eq 'ClientID'
            }
        }
    }

    It 'Should return nothing if TeamViewer if not installed' {
        Mock Test-TeamViewerInstallation { $false }
        Get-TeamViewerId | Should -BeNullOrEmpty
        Assert-MockCalled Get-ItemPropertyValue -Scope It -Times 0
    }

    It 'Should return nothing on unsupported platforms' {
        Mock Get-OperatingSystem { 'SomeOtherPlatform' }
        Mock Test-TeamViewerInstallation { $true }
        Get-TeamViewerId | Should -BeNullOrEmpty
    }
}
