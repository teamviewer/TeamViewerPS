BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Remove-TeamViewerUserGroupMember.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }

    $testAPIToken = [securestring]@{}
    $null = $testAPIToken
    $testMembers = @(123, 456, 789)
    $testMemberId = @('u101')
    $null = $testMemberId
    $testUserGroupMembers = @(
        @{AccountId = $testMembers[0]; Name = 'test account 1' }
        @{AccountId = $testMembers[1]; Name = 'test account 2' }
        @{AccountId = $testMembers[2]; Name = 'test account 3' }
    )
    $null = $testUserGroupMembers
    $testUserGroupId = 1001
    $null = $testUserGroupId
    $testUserGroupMember = @($testMembers[0], $testMembers[1], $testMembers[2])
    $null = $testUserGroupMember

    Mock Get-TeamViewerAPIUri { '//unit.test' }
    $mockArgs = @{}
    Mock Invoke-TeamViewerRestMethod { $mockArgs.Body = $Body }
}

Describe 'Remove-TeamViewerUserGroupMember' {
    Context 'Parameter aliases' {
        It 'Should expose <Alias> as an alias of the <Param> parameter' -ForEach @(
            @{ Param = 'UserGroupMember'; Alias = 'UserGroupMemberId' }
            @{ Param = 'UserGroupMember'; Alias = 'MemberId' }
            @{ Param = 'UserGroupMember'; Alias = 'UserId' }
            @{ Param = 'UserGroupMember'; Alias = 'User' }
            @{ Param = 'UserGroupMember'; Alias = 'UserGroupMemberIds' }
            @{ Param = 'UserGroupMember'; Alias = 'MemberIds' }
            @{ Param = 'UserGroupMember'; Alias = 'UserIds' }
        ) {
            (Get-Command -Name Remove-TeamViewerUserGroupMember).Parameters[$Param].Aliases | Should -Contain $Alias
        }
    }
    Context 'Should  remove members ByUserGroupMember' {

        It 'Should call the correct API endpoint' {
            Remove-TeamViewerUserGroupMember -APIToken $testAPIToken -UserGroup $testUserGroupId -UserGroupMember $testUserGroupMember

            Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
                $APIToken -eq $testAPIToken -and $Uri -eq "//unit.test/usergroups/$testUserGroupId/members" -and $Method -eq 'Delete' }
        }

        It 'Should remove a single user from the user group' {
            Remove-TeamViewerUserGroupMember -APIToken $testAPIToken -UserGroup $testUserGroupId -UserGroupMember $testMemberId

            $mockArgs.Body | Should -Not -BeNullOrEmpty
            $Body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
            $Body | Should -HaveCount 1
            $Body | Should -Contain $testMemberId.trim('u')
        }

        It 'Should handle domain object as input' {
            $testUserGroup = @{Id = $testUserGroupId; Name = 'test user group' } | ConvertTo-TeamViewerUserGroup

            Remove-TeamViewerUserGroupMember -APIToken $testAPIToken -UserGroup $testUserGroup -UserGroupMember $testUserGroupMember

            Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
                $APIToken -eq $testAPIToken -and $Uri -eq "//unit.test/usergroups/$testUserGroupId/members" -and $Method -eq 'Delete' }
        }

        It 'Should add the given members to the user group' {
            Remove-TeamViewerUserGroupMember -APIToken $testAPIToken -UserGroup $testUserGroupId -UserGroupMember $testUserGroupMember

            $mockArgs.Body | Should -Not -BeNullOrEmpty
            $Body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
            $Body | Should -HaveCount 3
            $Body | Should -Contain $testMembers[0]
            $Body | Should -Contain $testMembers[1]
            $Body | Should -Contain $testMembers[2]
        }

        It 'Should accept pipeline input as int' {
            $testMembers | Remove-TeamViewerUserGroupMember -APIToken $testAPIToken -UserGroup $testUserGroupId

            $mockArgs.Body | Should -Not -BeNullOrEmpty
            $Body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
            $Body | Should -HaveCount 3
            $Body | Should -Contain $testMembers[0]
            $Body | Should -Contain $testMembers[1]
            $Body | Should -Contain $testMembers[2]
        }

        It 'Should accept pipeline input as obj' {
            $testUserGroupMember | Remove-TeamViewerUserGroupMember -APIToken $testAPIToken -UserGroup $testUserGroupId

            $mockArgs.Body | Should -Not -BeNullOrEmpty
            $Body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
            $Body | Should -HaveCount 3
            $Body | Should -Contain $testMembers[0]
            $Body | Should -Contain $testMembers[1]
            $Body | Should -Contain $testMembers[2]
        }

        It 'Should create chunks' {
            1..2 | Remove-TeamViewerUserGroupMember -APIToken $testAPIToken -UserGroup $testUserGroupId

            $mockArgs.Body | Should -Not -BeNullOrEmpty
            $Body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
            $Body | Should -HaveCount 2
        }
    }
}
