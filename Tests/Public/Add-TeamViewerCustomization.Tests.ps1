BeforeAll {
    . "$PSScriptRoot/../../docs/Cmdlets/Public/Add-TeamViewerCustomization.ps1"
    . "$PSScriptRoot/../../docs/Cmdlets/Public/Test-TeamViewerInstallation.ps1"
    . "$PSScriptRoot/../../docs/Cmdlets/Public/Get-TeamViewerInstallationDirectory.ps1"
    @(Get-ChildItem -Path "$PSScriptRoot/../../docs/Cmdlets/Private/*.ps1") | `
        ForEach-Object { . $_.FullName }
}

Describe 'Add-TeamViewerCustomization' {
    Context 'When only Id is provided' {
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

        It 'Should call TeamViewer.exe customize with the provided Id' {
            Mock Start-Process -ParameterFilter { $_.FilePath -eq 'TeamViewer.exe' -and $_.ArgumentList -eq 'customize --id 123"' }
            Add-TeamViewerCustomization -Id '123'
            Assert-MockCalled Start-Process -Scope It -Times 1
        }

        It 'Should resolve the customization error code' {
            Mock Resolve-CustomizationErrorCode {}
            Add-TeamViewerCustomization -Id '123'
            Assert-MockCalled Resolve-CustomizationErrorCode -Scope It -Times 1
        }
    }

    Context 'When only Path is provided' {
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

        It 'Should call TeamViewer.exe customize with the provided Path' {
            Mock Start-Process -ParameterFilter { $_.FilePath -eq 'TeamViewer.exe' -and $_.ArgumentList -eq 'customize --path C:\TeamViewer.zip"' }
            Add-TeamViewerCustomization -Path 'C:\TeamViewer.zip'
            Assert-MockCalled Start-Process -Scope It -Times 1
        }

        It 'Should resolve the customization error code' {
            Mock Resolve-CustomizationErrorCode {}
            Add-TeamViewerCustomization -Path 'C:\TeamViewer.zip'
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
            Add-TeamViewerCustomization -Id '123'
            Assert-MockCalled Start-Process -Scope It -Times 0
            Assert-MockCalled Write-Error -Scope It -Times 1
        }
    }
}
