BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Remove-TeamViewerCustomization.ps1"
    . "$PSScriptRoot\..\..\Cmdlets\Public\Get-TeamViewerInstallationDirectory.ps1"
    . "$PSScriptRoot\..\..\Cmdlets\Public\Test-TeamViewerInstallation.ps1"
    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | `
        ForEach-Object { . $_.FullName }
}

Describe 'Remove-TeamViewerCustomization' {
    Context 'When TeamViewer is installed' {
        BeforeAll {
            Mock Test-TeamViewerInstallation { $true }
            Mock Get-TeamViewerInstallationDirectory { 'testpath' }
            Mock Set-Location
            Mock Start-Process {
                $process = New-Object PSObject -Property @{
                    ExitCode = 0
                }
                $process
            }
            Mock Resolve-CustomizationErrorCode {}
        }

        It 'Should call TeamViewer.exe customize --remove' {
            Mock Start-Process -ParameterFilter { $_.FilePath -eq 'TeamViewer.exe' -and $_.ArgumentList -eq 'customize --remove"' }
            Remove-TeamViewerCustomization
            Assert-MockCalled Start-Process -Scope It -Times 1
        }

        It 'Should resolve the customization error code' {
            Mock Resolve-CustomizationErrorCode {}
            Remove-TeamViewerCustomization
            Assert-MockCalled Resolve-CustomizationErrorCode -Scope It -Times 1
        }
    }

    Context 'When TeamViewer is not installed' {
        BeforeAll {
            Mock Test-TeamViewerInstallation { $false }
            Mock Write-Error {}
            Mock Start-Process {}
        }

        It 'Should write an error message' {
            Mock Write-Error -ParameterFilter { $_ -eq 'TeamViewer is not installed' }
            Remove-TeamViewerCustomization
            Assert-MockCalled Start-Process -Scope It -Times 0
            Assert-MockCalled Write-Error -Scope It -Times 1
        }
    }
}
