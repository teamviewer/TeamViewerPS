BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Get-TeamViewerInstallationDirectory.ps1"
    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | `
        ForEach-Object { . $_.FullName }
}

Describe 'Get-TeamViewerInstallationDirectory' {
    Context 'Windows' {
        BeforeAll {
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
            Should -Invoke Test-Path -Scope It -Times 1 -ParameterFilter {
                $Path -eq 'testRegistry'
            }
            Should -Invoke Get-Item -Scope It -Times 1 -ParameterFilter {
                $Path -eq 'testRegistry'
            }
            Should -Invoke Test-Path -Scope It -Times 1 -ParameterFilter {
                $Path -eq 'testPath/TeamViewer.exe'
            }
        }

        It 'Should return null if registry path does not exist' {
            Mock Test-Path -ParameterFilter { $Path -eq 'testRegistry' } { $false }
            $result = Get-TeamViewerInstallationDirectory
            $result | Should -BeNull
        }
    }

}
