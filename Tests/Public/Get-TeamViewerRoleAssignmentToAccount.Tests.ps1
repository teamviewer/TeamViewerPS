BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Get-TeamViewerUserByRole.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | `
        ForEach-Object { . $_.FullName }

    Mock Get-TeamViewerApiUri { '//unit.test' }
    $Assigned = @('u201', 'u202')
    Mock Invoke-TeamViewerRestMethod { @{
            ContinuationToken = $null
            AssignedToUsers   = $Assigned
        } }

    $testApiToken = [securestring]@{}
    $null = $testApiToken
    $testRoleId = '72abbedc-9853-4fc8-9d28-fa35e207b048'
    $null = $testRoleId
}

Describe 'Get-TeamViewerUserByRole' {
    Context 'When retrieving role assignments' {
        It 'Should call the correct API endpoint' {
            Get-TeamViewerUserByRole -ApiToken $testApiToken -RoleId $testRoleId

            Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
                $ApiToken -eq $testApiToken -And `
                    $Uri -eq "//unit.test/userroles/assignments/account?RoleId=$testRoleId" -And $Method -eq 'Get'
            }
        }

        It 'Should return assigned users' {
            $result = Get-TeamViewerUserByRole -ApiToken $testApiToken -RoleId $testRoleId
            $result | Should -HaveCount 2
        }

    }
}
