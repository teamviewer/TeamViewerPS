BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Add-TeamViewerUserGroupMember.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }

    $testApiToken = [securestring]@{}
    $null = $testApiToken
    $testMembers = @(123, 456, 789)
    $null = $testMembers
    $testMemberWithU = @('u101')
    $null = $testMemberWithU
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
        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -and $Uri -eq "//unit.test/usergroups/$testUserGroupId/members" -and $Method -eq 'Post' }
    }

    It 'Should handle domain object as input' {
        $testUserGroup = @{Id = $testUserGroupId; Name = 'test user group' } | ConvertTo-TeamViewerUserGroup
        Add-TeamViewerUserGroupMember -ApiToken $testApiToken -UserGroup $testUserGroup -Member $testMembers
        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -and $Uri -eq "//unit.test/usergroups/$testUserGroupId/members" -and $Method -eq 'Post' }
    }

    It 'Should add a single member to the user group with format u[0-9]+' {
        Add-TeamViewerUserGroupMember -ApiToken $testApiToken -UserGroup $testUserGroupId -Member $testMemberWithU
        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $Body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $Body | Should -HaveCount 1
        $Body | Should -Contain $testMemberWithU.trim('u')
    }

    It 'Should add the given members to the user group' {
        Add-TeamViewerUserGroupMember -ApiToken $testApiToken -UserGroup $testUserGroupId -Member $testMembers
        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $Body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $Body | Should -HaveCount 3
        $Body | Should -Contain $testMembers[0]
        $Body | Should -Contain $testMembers[1]
        $Body | Should -Contain $testMembers[2]
    }

    It 'Should accept pipeline input' {
        $testMembers | Add-TeamViewerUserGroupMember -ApiToken $testApiToken -UserGroup $testUserGroupId
        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $Body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $Body | Should -HaveCount 3
        $Body | Should -Contain $testMembers[0]
        $Body | Should -Contain $testMembers[1]
        $Body | Should -Contain $testMembers[2]
    }

    It 'Should create chunks' {
        1..250 | Add-TeamViewerUserGroupMember -ApiToken $testApiToken -UserGroup $testUserGroupId
        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $Body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $Body | Should -HaveCount 50
    }
}
