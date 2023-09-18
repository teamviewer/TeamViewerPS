BeforeAll {
    . "$PSScriptRoot/../../Docs/Cmdlets/Public/Get-TeamViewerInstallationDirectory.ps1"
    . "$PSScriptRoot/../../Docs/Cmdlets/Public/Test-TeamViewerInstallation.ps1"
    @(Get-ChildItem -Path "$PSScriptRoot/../../Docs/Cmdlets/Private/*.ps1") | `
        ForEach-Object { . $_.FullName }
}

Describe 'Test-TeamViewerInstallation' {
    Context 'TeamViewer installed' {
        BeforeAll {
            Mock Get-TeamViewerInstallationDirectory { 'C:\Program Files\TeamViewer' }
        }

        It 'Should return true if TeamViewer is installed' {
            $result = Test-TeamViewerInstallation
            $result | Should -Be $true
        }
    }

    Context 'TeamViewer not installed' {
        BeforeAll {
            Mock Get-TeamViewerInstallationDirectory { $null }
        }

        It 'Should return false if TeamViewer is not installed' {
            $result = Test-TeamViewerInstallation
            $result | Should -Be $false
        }
    }
}

