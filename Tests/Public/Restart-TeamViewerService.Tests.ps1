BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Restart-TeamViewerService.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | `
        ForEach-Object { . $_.FullName }

    if (-Not (Get-Command -Name 'Restart-Service' -ErrorAction SilentlyContinue)) {
        function Restart-Service {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidOverwritingBuiltInCmdlets", "", Justification = "Command not available on non-Windows platforms")]
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSReviewUnusedParameter", "", Justification = "Parameter only required for mocking")]
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "", Justification = "Function only required for mocking")]
            param($Name)
        }
    }
}

Describe 'Restart-TeamViewerService' {
    Context 'Windows' {
        BeforeAll {
            Mock Get-OperatingSystem { 'Windows' }
            Mock Get-TeamViewerServiceName { 'UnitTestTeamViewer' }
            Mock Restart-Service {}
        }
        It 'Should restart the TeamViewer Windows service' {
            Restart-TeamViewerService | Out-Null
            Assert-MockCalled Restart-Service -Scope It -Times 1 -ParameterFilter {
                $Name -eq 'UnitTestTeamViewer'
            }
        }
    }
    Context 'Linux' {
        BeforeAll {
            Mock Get-OperatingSystem { 'Linux' }
            Mock Invoke-ExternalCommand {}
        }
        It 'Should restart the TeamViewer daemon' {
            Restart-TeamViewerService | Out-Null
            Assert-MockCalled Invoke-ExternalCommand -Scope It -Times 1 -ParameterFilter {
                $Command -eq '/opt/teamviewer/tv_bin/script/teamviewer'
                $CommandArgs[0] -eq 'daemon' -and $CommandArgs[1] -eq 'restart'
            }
        }
    }
}
