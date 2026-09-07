BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Get-TeamViewerUserGroup.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }

    $testAPIToken = [securestring]@{}
    $null = $testAPIToken
    $UserGroups_Test = @(
        @{ id = 1001; name = 'test user group 1' },
        @{ id = 1002; name = 'test user group 2' },
        @{ id = 1003; name = 'test user group 3' }
    )
    $testUserGroupId = $UserGroups_Test[0].id
    $null = $testUserGroupId

    Mock Get-TeamViewerAPIUri { '//unit.test' }
}

Describe 'Get-TeamViewerUserGroup' {

    Context 'Should return all user groups' {
        BeforeAll {
            Mock Invoke-TeamViewerRestMethod { @{
                    nextPaginationToken = $null
                    resources           = $UserGroups_Test
                } }
        }

        It 'Should call the correct API endpoint to list user groups' {
            Get-TeamViewerUserGroup -APIToken $testAPIToken

            Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
                $APIToken -eq $testAPIToken -and $Uri -eq '//unit.test/usergroups' -and $Method -eq 'Get' }
        }

        It 'Should return UserGroup objects' {
            $Result = Get-TeamViewerUserGroup -APIToken $testAPIToken
            $Result | Should -HaveCount 3
            $Result[0].PSObject.TypeNames | Should -Contain 'TeamViewerPS.UserGroup'
        }

        It 'Should fetch consecutive pages' {
            Mock Invoke-TeamViewerRestMethod { @{
                    nextPaginationToken = 'abc'
                    resources           = $UserGroups_Test
                } }

            Mock Invoke-TeamViewerRestMethod { @{
                    nextPaginationToken = $null
                    resources           = @(
                        @{ id = 1004; name = 'test user group 4' }
                    )
                } } -ParameterFilter { $Body -and $Body['paginationToken'] -eq 'abc' }

            $Result = Get-TeamViewerUserGroup -APIToken $testAPIToken
            $Result | Should -HaveCount 4

            Should -Invoke Invoke-TeamViewerRestMethod -Times 2 -Scope It
        }
    }

    Context 'Should retrive a single group' {
        BeforeAll {
            Mock Invoke-TeamViewerRestMethod { $UserGroups_Test[0] }
        }

        It 'Should call the correct API endpoint for single user group' {
            Get-TeamViewerUserGroup -APIToken $testAPIToken -UserGroup $testUserGroupId

            Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
                $APIToken -eq $testAPIToken -and $Uri -eq "//unit.test/usergroups/$testUserGroupId" -and $Method -eq 'Get' }
        }

        It 'Should handle domain object as input' {
            $testUserGroup = @{Id = $testUserGroupId; Name = 'test user group' } | ConvertTo-TeamViewerUserGroup

            Get-TeamViewerUserGroup -APIToken $testAPIToken -UserGroup $testUserGroup

            Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
                $APIToken -eq $testAPIToken -and $Uri -eq "//unit.test/usergroups/$testUserGroupId" -and $Method -eq 'Get' }
        }

        It 'Should return a UserGroup object' {
            $Result = Get-TeamViewerUserGroup -APIToken $testAPIToken -UserGroup $testUserGroupId
            $Result | Should -BeOfType ([pscustomobject])
            $Result.PSObject.TypeNames | Should -Contain 'TeamViewerPS.UserGroup'
            $Result.id | Should -Be $UserGroups_Test[0].id
            $Result.name | Should -Be $UserGroups_Test[0].name
        }
    }
}
