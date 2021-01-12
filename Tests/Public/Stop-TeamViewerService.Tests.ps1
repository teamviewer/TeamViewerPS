BeforeAll {
    . "$PSScriptRoot/../../TeamViewerPS/Public/Stop-TeamViewerService.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot/../../TeamViewerPS/Private/*.ps1") | `
    ForEach-Object { . $_.FullName }

    if (-Not (Get-Command -Name 'Stop-Service' -ErrorAction SilentlyContinue)) {
        function Stop-Service {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidOverwritingBuiltInCmdlets", "", Justification = "Command not available on non-Windows platforms")]
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSReviewUnusedParameter", "", Justification = "Parameter only required for mocking")]
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "", Justification = "Function only required for mocking")]
            param($Name)
        }
    }
}

Describe 'Stop-TeamViewerService' {
    Context 'Windows' {
        BeforeAll {
            Mock Get-OperatingSystem { 'Windows' }
            Mock Get-TeamViewerServiceName { 'UnitTestTeamViewer' }
            Mock Stop-Service {}
        }
        It 'Should stop the TeamViewer Windows service' {
            Stop-TeamViewerService | Out-Null
            Assert-MockCalled Stop-Service -Scope It -Times 1 -ParameterFilter {
                $Name -eq 'UnitTestTeamViewer'
            }
        }
    }
    Context 'Linux' {
        BeforeAll {
            Mock Get-OperatingSystem { 'Linux' }
            Mock Invoke-ExternalCommand {}
        }
        It 'Should stop the TeamViewer daemon' {
            Stop-TeamViewerService | Out-Null
            Assert-MockCalled Invoke-ExternalCommand -Scope It -Times 1 -ParameterFilter {
                $Command -eq '/opt/teamviewer/tv_bin/script/teamviewer' -And
                $CommandArgs[0] -eq 'daemon' -and $CommandArgs[1] -eq 'stop'
            }
        }
    }
}
