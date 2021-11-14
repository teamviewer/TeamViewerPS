BeforeAll {
    . "$PSScriptRoot/../../TeamViewerPS/Public/Add-TeamViewerUserGroupMember.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot/../../TeamViewerPS/Private/*.ps1") | `
        ForEach-Object { . $_.FullName }

    $testApiToken = [securestring]@{}
    $null = $testApiToken
    $testMembers = @(123, 456, 789)
    $null = $testMembers
    $testUserGroupId = 1001
    $null = $testUserGroupId

    Mock Get-TeamViewerApiUri { '//unit.test' }
    $mockArgs = @{}
    Mock Invoke-TeamViewerRestMethod { $mockArgs.Body = $Body }
}

Describe 'Add-TeamViewerUserGroupMember' {
    It 'Should call the correct API endpoint' {
        Add-TeamViewerUserGroupMember `
            -ApiToken $testApiToken `
            -UserGroup $testUserGroupId `
            -Member $testMembers
        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And `
            $Uri -eq "//unit.test/usergroups/$testUserGroupId/members" -And `
            $Method -eq 'Post' }
    }

    It 'Should handle domain object as input' {
        $testUserGroup = @{Id = $testUserGroupId; Name = 'test user group' } | ConvertTo-TeamViewerUserGroup
        Add-TeamViewerUserGroupMember `
            -ApiToken $testApiToken `
            -UserGroup $testUserGroup `
            -Member $testMembers
        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And `
            $Uri -eq "//unit.test/usergroups/$testUserGroupId/members" -And `
            $Method -eq 'Post' }
    }

    It 'Should add the given members to the user group' {
        Add-TeamViewerUserGroupMember `
            -ApiToken $testApiToken `
            -UserGroup $testUserGroupId `
            -Member $testMembers
        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $body | Should -HaveCount 3
        $body | Should -Contain $testMembers[0]
        $body | Should -Contain $testMembers[1]
        $body | Should -Contain $testMembers[2]
    }

    It 'Should accept pipeline input' {
        $testMembers | Add-TeamViewerUserGroupMember `
            -ApiToken $testApiToken `
            -UserGroup $testUserGroupId
        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $body | Should -HaveCount 3
        $body | Should -Contain $testMembers[0]
        $body | Should -Contain $testMembers[1]
        $body | Should -Contain $testMembers[2]
    }

    It 'Should create chenks' {
        1..250 | Add-TeamViewerUserGroupMember `
            -ApiToken $testApiToken `
            -UserGroup $testUserGroupId
        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $body | Should -HaveCount 50
    }
}
