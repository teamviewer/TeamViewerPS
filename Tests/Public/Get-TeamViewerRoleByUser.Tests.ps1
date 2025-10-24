BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Get-TeamViewerRoleByUser.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | `
        ForEach-Object { . $_.FullName }

    Mock Get-TeamViewerApiUri { '//unit.test' }
    Mock Invoke-TeamViewerRestMethod { @{
            assignedRoleId = "00000000-0000-0000-0000-000000000000"
        } }

    $testApiToken = [securestring]@{}
    $null = $testApiToken
    $testUserId = 'u123456777'
    $null = $testUserId
}

Describe 'Get-TeamViewerUserByRole' {
    Context 'When retrieving role assignments' {
        It 'Should call the correct API endpoint' {
            Get-TeamViewerRoleByUser -ApiToken $testApiToken -UserId $testUserId

            Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
                $ApiToken -eq $testApiToken -And `
                    $Uri -eq "//unit.test/users/$testUserId/userroles" -And `
                    $Method -eq 'Get'
            }
        }

        It 'Should return assigned users' {
            $result = Get-TeamViewerRoleByUser -ApiToken $testApiToken -UserId $testUserId
            $result | Should -HaveCount 1
        }

    }
}
