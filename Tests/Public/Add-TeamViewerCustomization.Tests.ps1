BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Add-TeamViewerCustomization.ps1"
    . "$PSScriptRoot\..\..\Cmdlets\Public\Test-TeamViewerInstallation.ps1"
    . "$PSScriptRoot\..\..\Cmdlets\Public\Get-TeamViewerInstallationDirectory.ps1"
    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }
}

Describe 'Add-TeamViewerCustomization' {
    Context 'When only Id is provided' {
        BeforeAll {
            Mock Test-TeamViewerInstallation { $true }
            Mock Get-TeamViewerInstallationDirectory { 'testpath' }
            Mock Start-Process {
                [pscustomobject]@{ ExitCode = 0 }
            }
            Mock Resolve-TeamViewerCustomizationErrorCode {}
        }

        It 'Should call TeamViewer.exe customize with the provided Id' {
            Mock Start-Process -ParameterFilter {
                $FilePath -eq (Join-Path -Path 'testpath' -ChildPath 'TeamViewer.exe') -and
                $ArgumentList -eq 'customize --id 123'
            } {
                [pscustomobject]@{ ExitCode = 0 }
            }

            Add-TeamViewerCustomization -Id '123'

            Should -Invoke Start-Process -Scope It -Times 1
        }

        It 'Should resolve the customization error code' {
            Mock Resolve-TeamViewerCustomizationErrorCode {}

            Add-TeamViewerCustomization -Id '123'

            Should -Invoke Resolve-TeamViewerCustomizationErrorCode -Scope It -Times 1
        }
    }

    Context 'When only Path is provided' {
        BeforeAll {
            Mock Test-TeamViewerInstallation { $true }
            Mock Get-TeamViewerInstallationDirectory { 'testpath' }
            Mock Start-Process {
                [pscustomobject]@{ ExitCode = 0 }
            }
            Mock Resolve-TeamViewerCustomizationErrorCode {}
        }

        It 'Should call TeamViewer.exe customize with the provided Path' {
            Mock Start-Process -ParameterFilter {
                $FilePath -eq (Join-Path -Path 'testpath' -ChildPath 'TeamViewer.exe') -and
                $ArgumentList -eq 'customize --path C:\TeamViewer.zip'
            } {
                [pscustomobject]@{ ExitCode = 0 }
            }

            Add-TeamViewerCustomization -Path 'C:\TeamViewer.zip'

            Should -Invoke Start-Process -Scope It -Times 1
        }

        It 'Should resolve the customization error code' {
            Mock Resolve-TeamViewerCustomizationErrorCode {}

            Add-TeamViewerCustomization -Path 'C:\TeamViewer.zip'

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

            Add-TeamViewerCustomization -Id '123'

            Should -Invoke Start-Process -Scope It -Times 0
            Should -Invoke Write-Error -Scope It -Times 1
        }
    }

    It 'Should not start the process when WhatIf is used' {
        Mock Test-TeamViewerInstallation { $true }
        Mock Get-TeamViewerInstallationDirectory { 'testpath' }
        Mock Start-Process {}

        Add-TeamViewerCustomization -Id '123' -WhatIf

        Should -Invoke Start-Process -Scope It -Times 0
    }
}
