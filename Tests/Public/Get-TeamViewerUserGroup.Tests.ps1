BeforeAll {
    . "$PSScriptRoot/../../Docs/Cmdlets/Public/Get-TeamViewerUserGroup.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot/../../Docs/Cmdlets/Private/*.ps1") | `
        ForEach-Object { . $_.FullName }

    $testApiToken = [securestring]@{}
    $null = $testApiToken
    $testUserGroups = @(
        @{ id = 1001; name = 'test user group 1' },
        @{ id = 1002; name = 'test user group 2' },
        @{ id = 1003; name = 'test user group 3' }
    )
    $testUserGroupId = $testUserGroups[0].id
    $null = $testUserGroupId

    Mock Get-TeamViewerApiUri { '//unit.test' }
}

Describe 'Get-TeamViewerUserGroup' {

    Context 'Should return all user groups' {
        BeforeAll {
            Mock Invoke-TeamViewerRestMethod { @{
                    nextPaginationToken = $null
                    resources           = $testUserGroups
                } }
        }

        It 'Should call the correct API endpoint to list user groups' {
            Get-TeamViewerUserGroup -ApiToken $testApiToken

            Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
                $ApiToken -eq $testApiToken -And `
                $Uri -eq '//unit.test/usergroups' -And `
                $Method -eq 'Get' }
        }

        It 'Should return UserGroup objects' {
            $result = Get-TeamViewerUserGroup -ApiToken $testApiToken
            $result | Should -HaveCount 3
            $result[0].PSObject.TypeNames | Should -Contain 'TeamViewerPS.UserGroup'
        }

        It 'Should fetch consecutive pages' {
            Mock Invoke-TeamViewerRestMethod { @{
                    nextPaginationToken = 'abc'
                    resources           = $testUserGroups
                } }
            Mock Invoke-TeamViewerRestMethod { @{
                    nextPaginationToken = $null
                    resources           = @(
                        @{ id = 1004; name = 'test user group 4' }
                    )
                } } -ParameterFilter { $Body -And $Body['paginationToken'] -eq 'abc' }

            $result = Get-TeamViewerUserGroup -ApiToken $testApiToken
            $result | Should -HaveCount 4

            Assert-MockCalled Invoke-TeamViewerRestMethod -Times 2 -Scope It
        }
    }

    Context 'Should retrive a single group' {
        BeforeAll {
            Mock Invoke-TeamViewerRestMethod { $testUserGroups[0] }
        }

        It 'Should call the correct API endpoint for single user group' {
            Get-TeamViewerUserGroup -ApiToken $testApiToken -UserGroup $testUserGroupId

            Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
                $ApiToken -eq $testApiToken -And `
                $Uri -eq "//unit.test/usergroups/$testUserGroupId" -And `
                $Method -eq 'Get' }
        }

        It 'Should handle domain object as input' {
            $testUserGroup = @{Id = $testUserGroupId; Name = 'test user group' } | ConvertTo-TeamViewerUserGroup
            Get-TeamViewerUserGroup -ApiToken $testApiToken -UserGroup $testUserGroup

            Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
                $ApiToken -eq $testApiToken -And `
                $Uri -eq "//unit.test/usergroups/$testUserGroupId" -And `
                $Method -eq 'Get' }
        }

        It 'Should return a UserGroup object' {
            $result = Get-TeamViewerUserGroup -ApiToken $testApiToken -UserGroup $testUserGroupId
            $result | Should -BeOfType PSObject
            $result.PSObject.TypeNames | Should -Contain 'TeamViewerPS.UserGroup'
            $result.id | Should -Be $testUserGroups[0].id
            $result.name | Should -Be $testUserGroups[0].name
        }
    }
}
