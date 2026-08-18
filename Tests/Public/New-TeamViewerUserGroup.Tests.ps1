BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\New-TeamViewerUserGroup.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }

    $testApiToken = [securestring]@{}
    $null = $testApiToken
    $mockArgs = @{}
    $testUserGroupId = 1001
    $testUserGroupName = 'This is a test user group'

    Mock Get-TeamViewerApiUri { '//unit.test' }
    Mock Invoke-TeamViewerRestMethod {
        $mockArgs.Body = $Body
        @{
            id   = $testUserGroupId
            name = $testUserGroupName
        }
    }
}

Describe 'New-TeamViewerUserGroup' {
    It 'Should call the correct API endpoint' {
        New-TeamViewerUserGroup -ApiToken $testApiToken -Name $testUserGroupName

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -and $Uri -eq '//unit.test/usergroups' -and $Method -eq 'Post' }
    }

    It 'Should include the given name in the request' {
        New-TeamViewerUserGroup -ApiToken $testApiToken -Name $testUserGroupName

        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $Body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $Body.name | Should -Be $testUserGroupName
    }

    It 'Should return a UserGroup object' {
        $Result = New-TeamViewerUserGroup -ApiToken $testApiToken -Name $testUserGroupName
        $Result | Should -Not -BeNullOrEmpty
        $Result | Should -BeOfType [PSObject]
        $Result.PSObject.TypeNames | Should -Contain 'TeamViewerPS.UserGroup'
        $Result.id | Should -Be $testUserGroupId
        $Result.name | Should -Be $testUserGroupName
    }
}
