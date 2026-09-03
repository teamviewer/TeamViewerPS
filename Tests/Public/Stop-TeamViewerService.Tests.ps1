BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Stop-TeamViewerService.ps1"
    . "$PSScriptRoot\..\..\Cmdlets\Public\Test-TeamViewerInstallation.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }

    if (-not (Get-Command -Name 'Stop-Service' -ErrorAction SilentlyContinue)) {
        function Stop-Service {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidOverwritingBuiltInCmdlets', '', Justification = 'Command not available on non-Windows platforms')]
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Parameter only required for mocking')]
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification = 'Function only required for mocking')]
            param($Name)
        }
    }
}

Describe 'Stop-TeamViewerService' {
    Context 'When TeamViewer is installed' {
        BeforeAll {
            Mock Test-TeamViewerInstallation { $true }
            Mock Stop-Service {}
        }

        It 'Should stop the TeamViewer Windows service' {
            Stop-TeamViewerService | Out-Null

            Should -Invoke Stop-Service -Scope It -Times 1 -ParameterFilter {
                $Name -eq 'TeamViewer'
            }
        }
    }

    Context 'When WhatIf is specified' {
        BeforeAll {
            Mock Test-TeamViewerInstallation { $true }
            Mock Stop-Service {}
        }

        It 'Should not stop the service' {
            Stop-TeamViewerService -WhatIf | Out-Null

            Should -Invoke Stop-Service -Scope It -Times 0
        }
    }
}
