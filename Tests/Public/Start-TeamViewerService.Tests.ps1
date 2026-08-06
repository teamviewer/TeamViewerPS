BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Start-TeamViewerService.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | `
        ForEach-Object { . $_.FullName }

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
    BeforeAll {
        Mock Get-TeamViewerServiceName { 'UnitTestTeamViewer' }
        Mock Start-Service {}
    }
    It 'Should start the TeamViewer Windows service' {
        Start-TeamViewerService | Out-Null
        Should -Invoke Start-Service -Scope It -Times 1 -ParameterFilter {
            $Name -eq 'UnitTestTeamViewer'
        }
    }
}
