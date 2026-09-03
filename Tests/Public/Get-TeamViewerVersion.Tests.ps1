BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Get-TeamViewerVersion.ps1"

    . "$PSScriptRoot\..\..\Cmdlets\Public\Test-TeamViewerInstallation.ps1"
    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }

    Mock Get-ItemPropertyValue { '15.10.0' }
}

Describe 'Get-TeamViewerVersion' {
    BeforeAll {
        Mock Get-TeamViewerRegKeyPath { 'testRegistry' }
        Mock Test-TeamViewerInstallation { $true }
    }

    It 'Should return the TeamViewer Version from the Windows Registry' {
        Get-TeamViewerVersion | Should -Be '15.10.0'

        Should -Invoke Get-ItemPropertyValue -Scope It -Times 1 -ParameterFilter {
            $Path -eq 'testRegistry' -and $Name -eq 'Version'
        }
    }

    It 'Should return nothing if TeamViewer is not installed' {
        Mock Test-TeamViewerInstallation { $false }

        Get-TeamViewerVersion | Should -BeNullOrEmpty

        Should -Invoke Get-ItemPropertyValue -Scope It -Times 0
    }
}
