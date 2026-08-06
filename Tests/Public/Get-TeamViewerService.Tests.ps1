BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Get-TeamViewerService.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | `
        ForEach-Object { . $_.FullName }

    if (-Not (Get-Command -Name 'Get-Service' -ErrorAction SilentlyContinue)) {
        function Get-Service {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidOverwritingBuiltInCmdlets", "", Justification = "Command not available on non-Windows platforms")]
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSReviewUnusedParameter", "", Justification = "Parameter only required for mocking")]
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "", Justification = "Function only required for mocking")]
            param($Name)
        }
    }
}

Describe 'Get-TeamViewerService' {
    Context 'Windows' {
        BeforeAll {
            Mock Get-TeamViewerServiceName { 'UnitTestTeamViewer' }
            Mock Get-Service {}
        }
        It 'Should get the TeamViewer Windows service' {
            Get-TeamViewerService | Out-Null
            Should -Invoke Get-Service -Scope It -Times 1 -ParameterFilter {
                $Name -eq 'UnitTestTeamViewer'
            }
        }
    }
}
