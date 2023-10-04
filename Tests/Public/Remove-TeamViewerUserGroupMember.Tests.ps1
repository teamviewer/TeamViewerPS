BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Remove-TeamViewerUserGroupMember.ps1"
    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | `
        ForEach-Object { . $_.FullName }
    $testApiToken = [securestring]@{}
    $null = $testApiToken
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

    Mock Get-TeamViewerApiUri { '//unit.test' }
    $mockArgs = @{}
    Mock Invoke-TeamViewerRestMethod { $mockArgs.Body = $Body }
}

Describe 'Remove-TeamViewerUserGroupMember' {

    Context 'Should  remove members ByUserGroupMember' {

        It 'Should call the correct API endpoint' {
            Remove-TeamViewerUserGroupMember `
                -ApiToken $testApiToken `
                -UserGroup $testUserGroupId `
                -UserGroupMember $testUserGroupMember
            Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
                $ApiToken -eq $testApiToken -And `
                    $Uri -eq "//unit.test/usergroups/$testUserGroupId/members" -And `
                    $Method -eq 'Delete' }
        }

        It 'Should remove a single user from the user group' {
            Remove-TeamViewerUserGroupMember `
                -ApiToken $testApiToken `
                -UserGroup $testUserGroupId `
                -UserGroupMember $testMemberId
            $mockArgs.Body | Should -Not -BeNullOrEmpty
            $body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
            $body | Should -HaveCount 1
            $body | Should -Contain $testMemberId.trim('u')
        }

        It 'Should handle domain object as input' {
            $testUserGroup = @{Id = $testUserGroupId; Name = 'test user group' } | ConvertTo-TeamViewerUserGroup
            Remove-TeamViewerUserGroupMember `
                -ApiToken $testApiToken `
                -UserGroup $testUserGroup `
                -UserGroupMember $testUserGroupMember
            Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
                $ApiToken -eq $testApiToken -And `
                    $Uri -eq "//unit.test/usergroups/$testUserGroupId/members" -And `
                    $Method -eq 'Delete' }
        }

        It 'Should add the given members to the user group' {
            Remove-TeamViewerUserGroupMember `
                -ApiToken $testApiToken `
                -UserGroup $testUserGroupId `
                -UserGroupMember $testUserGroupMember
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
            $testUserGroupMember | Remove-TeamViewerUserGroupMember `
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
}
