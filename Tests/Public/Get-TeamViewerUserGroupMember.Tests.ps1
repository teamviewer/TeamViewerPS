BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Get-TeamViewerUserGroupMember.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }

    $testApiToken = [securestring]@{}
    $null = $testApiToken
    $testUserGroupMembers = @(
        @{ accountId = 2001; name = 'test account 1' },
        @{ accountId = 2002; name = 'test account 2' },
        @{ accountId = 2003; name = 'test account 3' }
    )
    $testUserGroupId = 1001
    $null = $testUserGroupId

    Mock Get-TeamViewerApiUri { '//unit.test' }
    Mock Invoke-TeamViewerRestMethod { @{
            nextPaginationToken = $null
            resources           = $testUserGroupMembers
        } }
}

Describe 'Get-TeamViewerUserGroupMember' {

    It 'Should call the correct API endpoint to list user group members' {
        Get-TeamViewerUserGroupMember -ApiToken $testApiToken -UserGroup $testUserGroupId

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -and $Uri -eq "//unit.test/usergroups/$testUserGroupId/members" -and $Method -eq 'Get' }
    }

    It 'Should handle domain object as input' {
        $testUserGroup = @{Id = $testUserGroupId; Name = 'test user group' } | ConvertTo-TeamViewerUserGroup

        Get-TeamViewerUserGroupMember -ApiToken $testApiToken -UserGroup $testUserGroup

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -and $Uri -eq "//unit.test/usergroups/$testUserGroupId/members" -and $Method -eq 'Get' }
    }

    It 'Should return UserGroupMember objects' {
        $Result = Get-TeamViewerUserGroupMember -ApiToken $testApiToken -UserGroup $testUserGroupId
        $Result | Should -HaveCount 3
        $Result[0].PSObject.TypeNames | Should -Contain 'TeamViewerPS.UserGroupMember'
    }

    It 'Should fetch consecutive pages' {
        Mock Invoke-TeamViewerRestMethod { @{
                nextPaginationToken = 'abc'
                resources           = $testUserGroupMembers
            } }

        Mock Invoke-TeamViewerRestMethod { @{
                nextPaginationToken = $null
                resources           = @(
                    @{ accountId = 2004; name = 'test account 4' }
                )
            } } -ParameterFilter { $Body -and $Body['paginationToken'] -eq 'abc' }

        $Result = Get-TeamViewerUserGroupMember -ApiToken $testApiToken -UserGroup $testUserGroupId
        $Result | Should -HaveCount 4

        Should -Invoke Invoke-TeamViewerRestMethod -Times 2 -Scope It
    }
}
