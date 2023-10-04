BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Get-TeamViewerVersion.ps1"

    . "$PSScriptRoot\..\..\Cmdlets\Public\Test-TeamViewerInstallation.ps1"
    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | `
        ForEach-Object { . $_.FullName }

    Mock Get-ItemPropertyValue { '15.10.0' }
}

Describe 'Get-TeamViewerVersion' {
    Context 'Windows' {
        BeforeAll {
            Mock Get-TeamViewerRegKeyPath { 'testRegistry' }
            Mock Get-OperatingSystem { 'Windows' }
            Mock Test-TeamViewerInstallation { $true }
        }

        It 'Should return the TeamViewer Version from the Windows Registry' {
            Get-TeamViewerVersion | Should -Be '15.10.0'
            Assert-MockCalled Get-ItemPropertyValue -Scope It -Times 1 -ParameterFilter {
                $Path -Eq 'testRegistry' -And $Name -Eq 'Version'
            }
        }
    }

    Context 'Linux' {
        BeforeAll {
            Mock Get-OperatingSystem { 'Linux' }
            Mock Test-TeamViewerInstallation { $true }
            Mock Get-TeamViewerLinuxGlobalConfig { '15.10.0' }
        }

        It 'Should return the TeamViewer version from the global configuration' {
            Get-TeamViewerVersion | Should -Be '15.10.0'
            Assert-MockCalled Get-TeamViewerLinuxGlobalConfig -Scope It -Times 1 -ParameterFilter {
                $Name -Eq 'Version'
            }
        }
    }

    It 'Should return nothing if TeamViewer is not installed' {
        Mock Test-TeamViewerInstallation { $false }
        Get-TeamViewerVersion | Should -BeNullOrEmpty
        Assert-MockCalled Get-ItemPropertyValue -Scope It -Times 0
    }

    It 'Should return nothing on unsupported platforms' {
        Mock Get-OperatingSystem { 'SomeOtherPlatform' }
        Mock Test-TeamViewerInstallation { $true }
        Get-TeamViewerVersion | Should -BeNullOrEmpty
    }
}
