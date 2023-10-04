BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Start-TeamViewerService.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | `
        ForEach-Object { . $_.FullName }

    if (-Not (Get-Command -Name 'Start-Service' -ErrorAction SilentlyContinue)) {
        function Start-Service {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidOverwritingBuiltInCmdlets", "", Justification = "Command not available on non-Windows platforms")]
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSReviewUnusedParameter", "", Justification = "Parameter only required for mocking")]
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "", Justification = "Function only required for mocking")]
            param($Name)
        }
    }
}

Describe 'Start-TeamViewerService' {
    Context 'Windows' {
        BeforeAll {
            Mock Get-OperatingSystem { 'Windows' }
            Mock Get-TeamViewerServiceName { 'UnitTestTeamViewer' }
            Mock Start-Service {}
        }
        It 'Should start the TeamViewer Windows service' {
            Start-TeamViewerService | Out-Null
            Assert-MockCalled Start-Service -Scope It -Times 1 -ParameterFilter {
                $Name -eq 'UnitTestTeamViewer'
            }
        }
    }
    Context 'Linux' {
        BeforeAll {
            Mock Get-OperatingSystem { 'Linux' }
            Mock Invoke-ExternalCommand {}
        }
        It 'Should start the TeamViewer daemon' {
            Start-TeamViewerService | Out-Null
            Assert-MockCalled Invoke-ExternalCommand -Scope It -Times 1 -ParameterFilter {
                $Command -eq '/opt/teamviewer/tv_bin/script/teamviewer' -And
                $CommandArgs[0] -eq 'daemon' -and $CommandArgs[1] -eq 'start'
            }
        }
    }
}
