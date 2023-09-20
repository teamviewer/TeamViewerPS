BeforeAll {
    . "$PSScriptRoot/../../docs/Cmdlets/Public/Get-TeamViewerCustomModuleId.ps1"
    . "$PSScriptRoot/../../docs/Cmdlets/Public/Test-TeamViewerInstallation.ps1"
    . "$PSScriptRoot/../../docs/Cmdlets/Public/Get-TeamViewerInstallationDirectory.ps1"
    @(Get-ChildItem -Path "$PSScriptRoot/../../docs/Cmdlets/Private/*.ps1") | `
        ForEach-Object { . $_.FullName }
}

Describe 'Get-TeamViewerCustomModuleId' {
    Context 'When TeamViewer is installed and customization is applied' {
        BeforeAll {
            Mock Test-TeamViewerInstallation { $true }
            Mock Test-Path { $true }
            Mock Get-Content { '{"id": "customModuleId"}' }
            Mock Get-TeamViewerInstallationDirectory {return 'C:\'}
            $installationDirectory = Get-TeamViewerInstallationDirectory
            $fileName ='TeamViewer.Json'
            $filePath = Join-Path -Path $installationDirectory -ChildPath $fileName
            Mock -CommandName Join-Path -MockWith {$filePath}
        }

        It 'Should return the custom module ID' {
            $expectedId = 'customModuleId'
            $result = Get-TeamViewerCustomModuleId
            $result | Should -Be $expectedId
        }
    }


    Context 'When TeamViewer is not installed' {
        BeforeAll {
            Mock Test-TeamViewerInstallation { $false }
            Mock Write-Error {}
        }

        It 'Should write an error message' {
            Mock Write-Error -ParameterFilter { $_ -eq 'TeamViewer is not installed' }
            Get-TeamViewerCustomModuleId
            Assert-MockCalled Write-Error -Scope It -Times 1
        }
    }

}


