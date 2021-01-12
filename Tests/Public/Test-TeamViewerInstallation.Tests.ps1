BeforeAll {
    . "$PSScriptRoot/../../TeamViewerPS/Public/Get-TeamViewerId.ps1"

    . "$PSScriptRoot/../../TeamViewerPS/Public/Test-TeamViewerInstallation.ps1"
    @(Get-ChildItem -Path "$PSScriptRoot/../../TeamViewerPS/Private/*.ps1") | `
        ForEach-Object { . $_.FullName }
}

Describe 'Test-TeamViewerInstallation' {
    Context 'Windows' {
        BeforeAll {
            Mock Get-OperatingSystem { 'Windows' }
            Mock Get-TeamViewerRegKeyPath { 'testRegistry' }
            Mock Get-ItemPropertyValue { 'testPath' }
            Mock Test-Path { $true }
        }

        It 'Should check the registry path and look for TeamViewer.exe' {
            Test-TeamViewerInstallation | Should -BeTrue
            Assert-MockCalled Test-Path -Scope It -Times 1 -ParameterFilter {
                $Path -eq 'testRegistry'
            }
            Assert-MockCalled Test-Path -Scope It -Times 1 -ParameterFilter {
                $Path -eq 'testPath/TeamViewer.exe'
            }
            Assert-MockCalled Get-ItemPropertyValue -Scope It -Times 1 -ParameterFilter {
                $Path -eq 'testRegistry' -And $Name -eq 'InstallationDirectory'
            }
        }

        It 'Should return false if registry path does not exist' {
            Mock Test-Path -ParameterFilter { $Path -eq 'testRegistry' } { $false }
            Test-TeamViewerInstallation | Should -BeFalse
        }

        It 'Should return false if TeamViewer.exe does not exist' {
            Mock Test-Path -ParameterFilter { $Path -eq 'testPath/TeamViewer.exe' } { $false }
            Test-TeamViewerInstallation | Should -BeFalse
        }
    }

    It 'Should return false on unsupported platforms' {
        Mock Get-OperatingSystem { 'SomeOtherPlatform' }
        Test-TeamViewerInstallation | Should -BeFalse
    }
}
