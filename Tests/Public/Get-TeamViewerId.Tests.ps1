BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Get-TeamViewerId.ps1"

    . "$PSScriptRoot\..\..\Cmdlets\Public\Test-TeamViewerInstallation.ps1"
    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }
    Mock Get-ItemPropertyValue { 123456 }
}

Describe 'Get-TeamViewerId' {
    BeforeAll {
        Mock Get-TeamViewerRegKeyPath { 'testRegistry' }
        Mock Test-TeamViewerInstallation { $true }
    }

    It 'Should return the TeamViewer ID from the Windows Registry' {
        Get-TeamViewerId | Should -Be 123456

        Should -Invoke Get-ItemPropertyValue -Scope It -Times 1 -ParameterFilter {
            $Path -eq 'testRegistry' -and $Name -eq 'ClientID'
        }
    }

    It 'Should return nothing if TeamViewer if not installed' {
        Mock Test-TeamViewerInstallation { $false }

        Get-TeamViewerId | Should -BeNullOrEmpty

        Should -Invoke Get-ItemPropertyValue -Scope It -Times 0
    }
}
