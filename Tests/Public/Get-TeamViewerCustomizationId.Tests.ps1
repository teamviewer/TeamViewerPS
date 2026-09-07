BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Get-TeamViewerCustomizationId.ps1"
    . "$PSScriptRoot\..\..\Cmdlets\Public\Test-TeamViewerInstallation.ps1"
    . "$PSScriptRoot\..\..\Cmdlets\Public\Get-TeamViewerInstallationDirectory.ps1"
    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }
}

Describe 'Get-TeamViewerCustomizationId' {
    Context 'When TeamViewer is installed and customization is applied' {
        BeforeAll {
            Mock Test-TeamViewerInstallation { $true }
            Mock Test-Path { $true }
            Mock Get-Content { '{"id": "customModuleId"}' }
            Mock Get-TeamViewerInstallationDirectory { return 'C:\' }

            $installationDirectory = Get-TeamViewerInstallationDirectory
            $fileName = 'TeamViewer.Json'
            $filePath = Join-Path -Path $installationDirectory -ChildPath $fileName

            Mock -CommandName Join-Path -MockWith { $filePath }
        }

        It 'Should return the custom module ID' {
            $expectedId = 'customModuleId'
            $Result = Get-TeamViewerCustomizationId
            $Result | Should -Be $expectedId
        }
    }


    Context 'When TeamViewer is not installed' {
        BeforeAll {
            Mock Test-TeamViewerInstallation { $false }
            Mock Write-Verbose { }
        }

        It 'Should write a verbose message' {
            $Result = Get-TeamViewerCustomizationId

            $Result | Should -BeNullOrEmpty

            Should -Invoke Write-Verbose -Scope It -Times 1 -ParameterFilter {
                $Message -eq 'TeamViewer is not installed!'
            }
        }
    }

    Context 'When the customization file is invalid' {
        BeforeAll {
            Mock Test-TeamViewerInstallation { $true }
            Mock Test-Path { $true }
            Mock Get-TeamViewerInstallationDirectory { 'C:\' }
            Mock Get-Content { throw 'invalid JSON' }
            Mock Write-Verbose { }
        }

        It 'Should write a verbose failure message' {
            $Result = Get-TeamViewerCustomizationId

            $Result | Should -BeNullOrEmpty

            Should -Invoke Write-Verbose -Scope It -Times 1 -ParameterFilter {
                $Message -like 'Failed to read the customization Id from*invalid JSON'
            }
        }
    }
}
