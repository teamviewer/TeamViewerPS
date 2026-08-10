BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Start-TeamViewerService.ps1"
    . "$PSScriptRoot\..\..\Cmdlets\Public\Test-TeamViewerInstallation.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }

    if (-not (Get-Command -Name 'Start-Service' -ErrorAction SilentlyContinue)) {
        function Start-Service {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidOverwritingBuiltInCmdlets', '', Justification = 'Command not available on non-Windows platforms')]
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Parameter only required for mocking')]
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification = 'Function only required for mocking')]
            param($Name)
        }
    }
}

Describe 'Start-TeamViewerService' {
    Context 'When TeamViewer is installed' {
        BeforeAll {
            Mock Test-TeamViewerInstallation { $true }
            Mock Start-Service {}
        }

        It 'Should start the TeamViewer Windows service' {
            Start-TeamViewerService | Out-Null

            Should -Invoke Start-Service -Scope It -Times 1 -ParameterFilter {
                $Name -eq 'TeamViewer'
            }
        }
    }

    Context 'When WhatIf is specified' {
        BeforeAll {
            Mock Test-TeamViewerInstallation { $true }
            Mock Start-Service {}
        }

        It 'Should not start the service' {
            Start-TeamViewerService -WhatIf | Out-Null

            Should -Invoke Start-Service -Scope It -Times 0
        }
    }
}
