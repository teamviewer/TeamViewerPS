BeforeAll {
    . "$PSScriptRoot/../../Docs/Cmdlets/Public/Get-TeamViewerRoleAssignmentToAccount.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot/../../Docs/Cmdlets/Private/*.ps1") | `
        ForEach-Object { . $_.FullName }

    Mock Get-TeamViewerApiUri { '//unit.test' }
    $Assigned = @('u201', 'u202')
    Mock Invoke-TeamViewerRestMethod { @{
            ContinuationToken = $null
            AssignedToUsers   = $Assigned
        } }

    $testApiToken = [securestring]@{}
    $null = $testApiToken
    $testUserRoleId = '72abbedc-9853-4fc8-9d28-fa35e207b048'
    $null = $testUserRoleId
}

Describe 'Get-TeamViewerRoleAssignmentToAccount' {
    Context 'When retrieving role assignments' {
        It 'Should call the correct API endpoint' {
            Get-TeamViewerRoleAssignmentToAccount -ApiToken $testApiToken -UserRoleId $testUserRoleId

            Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
                $ApiToken -eq $testApiToken -And `
                    $Uri -eq "//unit.test/userroles/assignments/account?userRoleId=$testUserRoleId" -And `
                    $Method -eq 'Get'
            }
        }

        It 'Should return assigned users' {
            $result = Get-TeamViewerRoleAssignmentToAccount -ApiToken $testApiToken -UserRoleId $testUserRoleId
            $result | Should -HaveCount 2
        }

    }
}
