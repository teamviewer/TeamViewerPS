BeforeAll {
    . "$PSScriptRoot/../../Docs/Cmdlets/Public/Get-TeamViewerInstallationDirectory.ps1"
    @(Get-ChildItem -Path "$PSScriptRoot/../../Docs/Cmdlets/Private/*.ps1") | `
        ForEach-Object { . $_.FullName }
}

Describe 'Get-TeamViewerInstallationDirectory' {
    Context 'Windows' {
        BeforeAll {
            Mock Get-OperatingSystem { 'Windows' }
            Mock Get-TeamViewerRegKeyPath { 'testRegistry' }
            Mock Test-Path { $true }
            function Get-TestItemValue([object]$obj) {
            }
            $testItem = [PSCustomObject]@{}
            $testItem | Add-Member `
                -MemberType ScriptMethod `
                -Name GetValue `
                -Value { param($obj) Get-TestItemValue @PSBoundParameters }
            Mock Get-TestItemValue { 'testPath' }
            Mock Get-Item { $testItem }
        }

        It 'Should check the registry path and return the installation directory' {
            $result = Get-TeamViewerInstallationDirectory
            $result | Should -Be 'testPath'
            Assert-MockCalled Test-Path -Scope It -Times 1 -ParameterFilter {
                $Path -eq 'testRegistry'
            }
            Assert-MockCalled Get-Item -Scope It -Times 1 -ParameterFilter {
                $Path -eq 'testRegistry'
            }
            Assert-MockCalled Test-Path -Scope It -Times 1 -ParameterFilter {
                $Path -eq 'testPath/TeamViewer.exe'
            }
        }

        It 'Should return null if registry path does not exist' {
            Mock Test-Path -ParameterFilter { $Path -eq 'testRegistry' } { $false }
            $result = Get-TeamViewerInstallationDirectory
            $result | Should -BeNull
        }
    }

    Context 'Linux' {
        BeforeAll {
            Mock Get-OperatingSystem { 'Linux' }
            Mock Test-Path { $true }
        }

        It 'Should return the Linux installation directory' {
            $result = Get-TeamViewerInstallationDirectory
            $result | Should -Be '/opt/teamviewer/tv_bin/'
            Assert-MockCalled Test-Path -Scope It -Times 1 -ParameterFilter {
                $Path -eq '/opt/teamviewer/tv_bin/TeamViewer'
            }
        }
    }

}
