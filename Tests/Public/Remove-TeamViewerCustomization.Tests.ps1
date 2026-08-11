BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Remove-TeamViewerCustomization.ps1"
    . "$PSScriptRoot\..\..\Cmdlets\Public\Get-TeamViewerInstallationDirectory.ps1"
    . "$PSScriptRoot\..\..\Cmdlets\Public\Test-TeamViewerInstallation.ps1"
    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }
}

Describe 'Remove-TeamViewerCustomization' {
    Context 'When TeamViewer is installed' {
        BeforeAll {
            Mock Test-TeamViewerInstallation { $true }
            Mock Get-TeamViewerInstallationDirectory { 'testpath' }
            Mock Start-Process {
                [pscustomobject]@{ ExitCode = 0 }
            }
            Mock Resolve-TeamViewerCustomizationErrorCode {}
        }

        It 'Should call TeamViewer.exe customize --remove' {
            Mock Start-Process -ParameterFilter {
                $FilePath -eq (Join-Path -Path 'testpath' -ChildPath 'TeamViewer.exe') -and
                $ArgumentList -eq 'customize --remove'
            } {
                [pscustomobject]@{ ExitCode = 0 }
            }

            Remove-TeamViewerCustomization

            Should -Invoke Start-Process -Scope It -Times 1
        }

        It 'Should resolve the customization error code' {
            Mock Resolve-TeamViewerCustomizationErrorCode {}

            Remove-TeamViewerCustomization

            Should -Invoke Resolve-TeamViewerCustomizationErrorCode -Scope It -Times 1
        }
    }

    Context 'When TeamViewer is not installed' {
        BeforeAll {
            Mock Test-TeamViewerInstallation { $false }
            Mock Get-TeamViewerInstallationDirectory { 'testpath' }
            Mock Write-Error {}
            Mock Start-Process {}
        }

        It 'Should write an error message' {
            Mock Write-Error -ParameterFilter { $Message -eq 'TeamViewer is not installed!' }

            Remove-TeamViewerCustomization

            Should -Invoke Start-Process -Scope It -Times 0
            Should -Invoke Write-Error -Scope It -Times 1
        }
    }

    It 'Should not start the process when WhatIf is used' {
        Mock Test-TeamViewerInstallation { $true }
        Mock Get-TeamViewerInstallationDirectory { 'testpath' }
        Mock Start-Process {}

        Remove-TeamViewerCustomization -WhatIf

        Should -Invoke Start-Process -Scope It -Times 0
    }
}
