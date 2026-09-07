BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Add-TeamViewerUserGroupToRole.ps1"
    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }

    $testAPIToken = [securestring]@{}
    $null = $testAPIToken
    $testUserGroup = 1234
    $null = $testUserGroup
    $testRoleId = '9b465ea2-2f75-4101-a057-58a81ed0e57b'
    $null = $testRoleId

    Mock Get-TeamViewerAPIUri { '//unit.test' }
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
        Add-TeamViewerUserGroupToRole -APIToken $testAPIToken -RoleId $testRoleId -UserGroup $testUserGroup

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $APIToken -eq $testAPIToken -and $Uri -eq '//unit.test/userroles/assign/usergroup' -and $Method -eq 'Post'
        }
    }

    # It 'Should return a Role/UserGroup object' {
    #Request doesn't return a response body
    # }
}
