BeforeAll {
    . "$PSScriptRoot/../../Docs/Cmdlets/Public/Get-TeamViewerRoleAssignmentToUserGroup.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot/../../Docs/Cmdlets/Private/*.ps1") | `
        ForEach-Object { . $_.FullName }

    Mock Get-TeamViewerApiUri { '//unit.test' }
    $Assigned = @('1001', '1002')
    Mock Invoke-TeamViewerRestMethod { @{
            ContinuationToken = $null
            AssignedToGroups   = $Assigned
        } }

    $testApiToken = [securestring]@{}
    $null = $testApiToken
    $testUserRoleId = '72abbedc-9853-4fc8-9d28-fa35e207b048'
    $null = $testUserRoleId
}

Describe 'Get-TeamViewerRoleAssignmentTouserGroup' {
    Context 'When retrieving role assignments' {
        It 'Should call the correct API endpoint' {
            Get-TeamViewerRoleAssignmentToUserGroup -ApiToken $testApiToken -UserRoleId $testUserRoleId

            Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
                $ApiToken -eq $testApiToken -And `
                    $Uri -eq "//unit.test/userroles/assignments/usergroups?userRoleId=$testUserRoleId" -And `
                    $Method -eq 'Get'
            }
        }

        It 'Should return assigned groups' {
            $result = Get-TeamViewerRoleAssignmentToUserGroup -ApiToken $testApiToken -UserRoleId $testUserRoleId
            $result | Should -HaveCount 2
        }

    }
}
