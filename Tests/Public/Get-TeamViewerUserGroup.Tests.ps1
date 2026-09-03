BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Get-TeamViewerUserGroup.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }

    $testApiToken = [securestring]@{}
    $null = $testApiToken
    $UserGroups_Test = @(
        @{ id = 1001; name = 'test user group 1' },
        @{ id = 1002; name = 'test user group 2' },
        @{ id = 1003; name = 'test user group 3' }
    )
    $testUserGroupId = $UserGroups_Test[0].id
    $null = $testUserGroupId

    Mock Get-TeamViewerApiUri { '//unit.test' }
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
            Get-TeamViewerUserGroup -ApiToken $testApiToken

            Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
                $ApiToken -eq $testApiToken -and $Uri -eq '//unit.test/usergroups' -and $Method -eq 'Get' }
        }

        It 'Should return UserGroup objects' {
            $Result = Get-TeamViewerUserGroup -ApiToken $testApiToken
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

            $Result = Get-TeamViewerUserGroup -ApiToken $testApiToken
            $Result | Should -HaveCount 4

            Should -Invoke Invoke-TeamViewerRestMethod -Times 2 -Scope It
        }
    }

    Context 'Should retrive a single group' {
        BeforeAll {
            Mock Invoke-TeamViewerRestMethod { $UserGroups_Test[0] }
        }

        It 'Should call the correct API endpoint for single user group' {
            Get-TeamViewerUserGroup -ApiToken $testApiToken -UserGroup $testUserGroupId

            Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
                $ApiToken -eq $testApiToken -and $Uri -eq "//unit.test/usergroups/$testUserGroupId" -and $Method -eq 'Get' }
        }

        It 'Should handle domain object as input' {
            $testUserGroup = @{Id = $testUserGroupId; Name = 'test user group' } | ConvertTo-TeamViewerUserGroup

            Get-TeamViewerUserGroup -ApiToken $testApiToken -UserGroup $testUserGroup

            Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
                $ApiToken -eq $testApiToken -and $Uri -eq "//unit.test/usergroups/$testUserGroupId" -and $Method -eq 'Get' }
        }

        It 'Should return a UserGroup object' {
            $Result = Get-TeamViewerUserGroup -ApiToken $testApiToken -UserGroup $testUserGroupId
            $Result | Should -BeOfType ([pscustomobject])
            $Result.PSObject.TypeNames | Should -Contain 'TeamViewerPS.UserGroup'
            $Result.id | Should -Be $UserGroups_Test[0].id
            $Result.name | Should -Be $UserGroups_Test[0].name
        }
    }
}
