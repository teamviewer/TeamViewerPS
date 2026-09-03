BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Get-TeamViewerInstallationDirectory.ps1"
    . "$PSScriptRoot\..\..\Cmdlets\Public\Test-TeamViewerInstallation.ps1"
    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }
}

Describe 'Test-TeamViewerInstallation' {
    Context 'TeamViewer installed' {
        BeforeAll {
            Mock Get-TeamViewerInstallationDirectory { 'C:\Program Files\TeamViewer' }
        }

        It 'Should return true if TeamViewer is installed' {
            $Result = Test-TeamViewerInstallation
            $Result | Should -Be $true
        }
    }

    Context 'TeamViewer not installed' {
        BeforeAll {
            Mock Get-TeamViewerInstallationDirectory { $null }
        }

        It 'Should return false if TeamViewer is not installed' {
            $Result = Test-TeamViewerInstallation
            $Result | Should -Be $false
        }
    }
}
