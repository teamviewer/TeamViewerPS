BeforeAll {
    . "$PSScriptRoot/../../docs/Cmdlets/Public/New-TeamViewerUserGroup.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot/../../docs/Cmdlets/Private/*.ps1") | `
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

Describe 'New-TeamViewerUserGroup' {

    It 'Should call the correct API endpoint' {
        New-TeamViewerUserGroup -ApiToken $testApiToken -Name $testUserGroupName

        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And `
            $Uri -eq '//unit.test/usergroups' -And `
            $Method -eq 'Post' }
    }

    It 'Should include the given name in the request' {
        New-TeamViewerUserGroup -ApiToken $testApiToken -Name  $testUserGroupName

        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $body.name | Should -Be  $testUserGroupName
    }

    It 'Should return a UserGroup object' {
        $result = New-TeamViewerUserGroup -ApiToken $testApiToken -Name  $testUserGroupName
        $result | Should -Not -BeNullOrEmpty
        $result | Should -BeOfType [PSObject]
        $result.PSObject.TypeNames | Should -Contain 'TeamViewerPS.UserGroup'
        $result.id | Should -Be $testUserGroupId
        $result.name | Should -Be $testUserGroupName
    }
}
