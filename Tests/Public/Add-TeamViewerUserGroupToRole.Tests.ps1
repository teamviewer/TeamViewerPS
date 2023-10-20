BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Add-TeamViewerUserGroupToRole.ps1"
    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | `
        ForEach-Object { . $_.FullName }

    $testApiToken = [securestring]@{}
    $null = $testApiToken
    $testUserGroup = 1234
    $null = $testUserGroup
    $testRoleId = '9b465ea2-2f75-4101-a057-58a81ed0e57b'
    $null = $testRoleId
    Mock Get-TeamViewerApiUri { '//unit.test' }
    $mockArgs = @{}
    Mock Invoke-TeamViewerRestMethod { $mockArgs.Body = $Body
        @{
            RoleId      = $testRoleId
            UserGroupId = $testUserGroup
        }
    }
}
Describe 'Add-TeamViewerUserGroupToRole' {
    It 'Should call the correct API endpoint' {
        Add-TeamViewerUserGroupToRole -ApiToken $testApiToken -RoleId $testRoleId -UserGroup $testUserGroup
        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And `
                $Uri -eq '//unit.test/userroles/assign/usergroup' -And `
                $Method -eq 'Post'
        }
    }

    # It 'Should return a UserRole/UserGroup object' {
    #Request doesn't return a response body
    # }


}
