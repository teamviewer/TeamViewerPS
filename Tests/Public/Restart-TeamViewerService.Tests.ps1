BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Restart-TeamViewerService.ps1"
    . "$PSScriptRoot\..\..\Cmdlets\Public\Test-TeamViewerInstallation.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }

    if (-not (Get-Command -Name 'Restart-Service' -ErrorAction SilentlyContinue)) {
        function Restart-Service {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidOverwritingBuiltInCmdlets', '', Justification = 'Command not available on non-Windows platforms')]
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Parameter only required for mocking')]
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification = 'Function only required for mocking')]
            param($Name)
        }
    }
}

Describe 'Restart-TeamViewerService' {
    Context 'When TeamViewer is installed' {
        BeforeAll {
            Mock Test-TeamViewerInstallation { $true }
            Mock Restart-Service {}
        }

        It 'Should restart the TeamViewer Windows service' {
            Restart-TeamViewerService | Out-Null

            Should -Invoke Restart-Service -Scope It -Times 1 -ParameterFilter {
                $Name -eq 'TeamViewer'
            }
        }
    }

    Context 'When WhatIf is specified' {
        BeforeAll {
            Mock Test-TeamViewerInstallation { $true }
            Mock Restart-Service {}
        }

        It 'Should not restart the service' {
            Restart-TeamViewerService -WhatIf | Out-Null

            Should -Invoke Restart-Service -Scope It -Times 0
        }
    }
}
