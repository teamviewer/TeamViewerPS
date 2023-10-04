BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Set-TeamViewerUserGroup.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | `
        ForEach-Object { . $_.FullName }

    $testApiToken = [securestring]@{}
    $null = $testApiToken
    $mockArgs = @{}
    $testUserGroupId = 1001
    $testUserGroupName = 'This is a test user group'

    Mock Get-TeamViewerApiUri { '//unit.test' }
    Mock Invoke-TeamViewerRestMethod {
        $mockArgs.Body = $Body
        @{
            id = $testUserGroupId
            name = $testUserGroupName
        }
    }
}

Describe 'Set-TeamViewerUserGroup' {

    It 'Should call the correct API endpoint' {
        Set-TeamViewerUserGroup `
            -ApiToken $testApiToken `
            -UserGroup $testUserGroupId `
            -Name $testUserGroupName

        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And `
            $Uri -eq "//unit.test/usergroups/$testUserGroupId" -And `
            $Method -eq 'Put' }
    }

    It 'Should handle domain object as input' {
        $testUserGroup = @{Id = $testUserGroupId; Name = 'test user group' } | ConvertTo-TeamViewerUserGroup
        Set-TeamViewerUserGroup `
            -ApiToken $testApiToken `
            -UserGroup $testUserGroup `
            -Name $testUserGroupName

        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And `
            $Uri -eq "//unit.test/usergroups/$testUserGroupId" -And `
            $Method -eq 'Put' }
    }

    It 'Should include the given name in the request' {
        Set-TeamViewerUserGroup `
            -ApiToken $testApiToken `
            -UserGroup $testUserGroupId `
            -Name  $testUserGroupName

        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $body.name | Should -Be  $testUserGroupName
    }

    It 'Should return a UserGroup object' {
        $result = Set-TeamViewerUserGroup `
            -ApiToken $testApiToken `
            -UserGroup $testUserGroupId `
            -Name  $testUserGroupName

        $result | Should -Not -BeNullOrEmpty
        $result | Should -BeOfType [PSObject]
        $result.PSObject.TypeNames | Should -Contain 'TeamViewerPS.UserGroup'
        $result.id | Should -Be $testUserGroupId
        $result.name | Should -Be $testUserGroupName
    }
}
