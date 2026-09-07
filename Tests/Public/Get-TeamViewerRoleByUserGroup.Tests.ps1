BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Get-TeamViewerRoleByUserGroup.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }

    Mock Get-TeamViewerAPIUri { '//unit.test' }
    Mock Invoke-TeamViewerRestMethod { @{
            assignedRoleId = 15
        } }

    $testAPIToken = [securestring]@{}
    $null = $testAPIToken
    $testGroupId = '113456'
    $null = $testGroupId
}

Describe 'Get-TeamViewerUserGroupByRole' {
    Context 'When retrieving role assignments' {
        It 'Should call the correct API endpoint' {
            Get-TeamViewerRoleByUserGroup -APIToken $testAPIToken -UserGroup $testGroupId

            Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
                $APIToken -eq $testAPIToken -and $Uri -eq "//unit.test/usergroups/$testGroupId/userroles" -and $Method -eq 'Get'
            }
        }

        It 'Should return assigned groups' {
            $Result = Get-TeamViewerRoleByUserGroup -APIToken $testAPIToken -UserGroup $testGroupId
            $Result | Should -HaveCount 1
            $Result.PSObject.TypeNames[0] | Should -Be 'TeamViewerPS.UserGroupRoleMembership'
            $Result.RoleId | Should -Be 15
        }
    }
}
