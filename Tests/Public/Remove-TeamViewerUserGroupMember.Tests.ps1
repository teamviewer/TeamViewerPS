BeforeAll {
    . "$PSScriptRoot/../../TeamViewerPS/Public/Remove-TeamViewerUserGroupMember.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot/../../TeamViewerPS/Private/*.ps1") | `
        ForEach-Object { . $_.FullName }

    $testApiToken = [securestring]@{}
    $null = $testApiToken
    $testMembers = @(123, 456, 789)
    $testUserGroupMembers = @(
        @{AccountId = $testMembers[0]; Name = 'test account 1' } | ConvertTo-TeamViewerUserGroupMember
        @{AccountId = $testMembers[1]; Name = 'test account 2' } | ConvertTo-TeamViewerUserGroupMember
        @{AccountId = $testMembers[2]; Name = 'test account 3' } | ConvertTo-TeamViewerUserGroupMember
    )
    $null = $testUserGroupMembers
    $testUsers = @('u123', 'u456', 'u789')
    $null = $testUsers
    $testUserGroupId = 1001
    $null = $testUserGroupId
    $testUserGroupMemberId = $testMembers[0]
    $null = $testUserGroupMemberId

    Mock Get-TeamViewerApiUri { '//unit.test' }
    $mockArgs = @{}
    Mock Invoke-TeamViewerRestMethod { $mockArgs.Body = $Body }
}

Describe 'Remove-TeamViewerUserGroupMember' {

    Context 'Should bulk remove members ByUserGroupMemberId' {

        It 'Should call the correct API endpoint' {
            Remove-TeamViewerUserGroupMember `
                -ApiToken $testApiToken `
                -UserGroup $testUserGroupId `
                -UserGroupMember $testMembers
            Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
                $ApiToken -eq $testApiToken -And `
                $Uri -eq "//unit.test/usergroups/$testUserGroupId/members" -And `
                $Method -eq 'Delete' }
        }

        It 'Should handle domain object as input' {
            $testUserGroup = @{Id = $testUserGroupId; Name = 'test user group' } | ConvertTo-TeamViewerUserGroup
            Remove-TeamViewerUserGroupMember `
                -ApiToken $testApiToken `
                -UserGroup $testUserGroup `
                -UserGroupMember $testMembers
            Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
                $ApiToken -eq $testApiToken -And `
                $Uri -eq "//unit.test/usergroups/$testUserGroupId/members" -And `
                $Method -eq 'Delete' }
        }

        It 'Should add the given members to the user group' {
            Remove-TeamViewerUserGroupMember `
                -ApiToken $testApiToken `
                -UserGroup $testUserGroupId `
                -UserGroupMember $testMembers
            $mockArgs.Body | Should -Not -BeNullOrEmpty
            $body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
            $body | Should -HaveCount 3
            $body | Should -Contain $testMembers[0]
            $body | Should -Contain $testMembers[1]
            $body | Should -Contain $testMembers[2]
        }

        It 'Should accept pipeline input as int' {
            $testMembers | Remove-TeamViewerUserGroupMember `
                -ApiToken $testApiToken `
                -UserGroup $testUserGroupId
            $mockArgs.Body | Should -Not -BeNullOrEmpty
            $body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
            $body | Should -HaveCount 3
            $body | Should -Contain $testMembers[0]
            $body | Should -Contain $testMembers[1]
            $body | Should -Contain $testMembers[2]
        }

        It 'Should accept pipeline input as obj' {
            $testUserGroupMembers | Remove-TeamViewerUserGroupMember `
                -ApiToken $testApiToken `
                -UserGroup $testUserGroupId
            $mockArgs.Body | Should -Not -BeNullOrEmpty
            $body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
            $body | Should -HaveCount 3
            $body | Should -Contain $testMembers[0]
            $body | Should -Contain $testMembers[1]
            $body | Should -Contain $testMembers[2]
        }

        It 'Should create chunks' {
            1..2 | Remove-TeamViewerUserGroupMember `
                -ApiToken $testApiToken `
                -UserGroup $testUserGroupId
            $mockArgs.Body | Should -Not -BeNullOrEmpty
            $body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
            $body | Should -HaveCount 2
        }
    }

    Context 'Should remove members ByUserId' {

        It 'Should call the correct API endpoint' {
            Remove-TeamViewerUserGroupMember `
                -ApiToken $testApiToken `
                -UserGroup $testUserGroupId `
                -User "u$testUserGroupMemberId"

            Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
                $ApiToken -eq $testApiToken -And `
                $Uri -eq "//unit.test/usergroups/$testUserGroupId/members" -And `
                $Method -eq 'Delete' }
        }

        It 'Should handle domain object as input' {
            $testUserGroup = @{Id = $testUserGroupId; Name = 'test user group' } | ConvertTo-TeamViewerUserGroup
            Remove-TeamViewerUserGroupMember `
                -ApiToken $testApiToken `
                -UserGroup $testUserGroup `
                -User $testUsers
            Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
                $ApiToken -eq $testApiToken -And `
                $Uri -eq "//unit.test/usergroups/$testUserGroupId/members" -And `
                $Method -eq 'Delete' }
        }

        It 'Should accept pipeline input as obj' {
            $testUsers | Remove-TeamViewerUserGroupMember `
                -ApiToken $testApiToken `
                -UserGroup $testUserGroupId
            $mockArgs.Body | Should -Not -BeNullOrEmpty
            $body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
            $body | Should -HaveCount 3
            $body | Should -Contain $testMembers[0]
            $body | Should -Contain $testMembers[1]
            $body | Should -Contain $testMembers[2]
        }
    }
}
