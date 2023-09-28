BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Get-TeamViewerUser.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | `
        ForEach-Object { . $_.FullName }

    $testApiToken = [securestring]@{}
    $null = $testApiToken

    Mock Get-TeamViewerApiUri { '//unit.test' }
    Mock Invoke-TeamViewerRestMethod { @{
            users = @(
                @{ id = 'u1234'; name = 'test user 1'; email = 'user1@unit.test' },
                @{ id = 'u4567'; name = 'test user 2'; email = 'user2@unit.test' },
                @{ id = 'u8901'; name = 'test user 3'; email = 'user3@unit.test' }
            )
        } }
}

Describe 'Get-TeamViewerUser' {

    It 'Should call the correct API endpoint to list users' {
        Get-TeamViewerUser -ApiToken $testApiToken

        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And `
                $Uri -eq '//unit.test/users' -And `
                $Method -eq 'Get' }
    }

    It 'Should call the correct API endpoint for single user' {
        Get-TeamViewerUser -ApiToken $testApiToken -User 'u1234'

        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And `
                $Uri -eq '//unit.test/users/u1234' -And `
                $Method -eq 'Get' }
    }

    It 'Should return User objects' {
        $result = Get-TeamViewerUser -ApiToken $testApiToken
        $result | Should -HaveCount 3
        $result[0].PSObject.TypeNames | Should -Contain 'TeamViewerPS.User'
    }

    It 'Should allow to filter by name' {
        Get-TeamViewerUser -ApiToken $testApiToken -Name 'TestName'
        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $Body -And $Body['name'] -eq 'TestName' }
    }

    It 'Should allow to filter by emails' {
        Get-TeamViewerUser -ApiToken $testApiToken -Email 'user1@unit.test', 'user2@unit.test'
        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $Body -And $Body['email'] -eq 'user1@unit.test,user2@unit.test' }
    }

    It 'Should allow to filter by permissions' {
        Get-TeamViewerUser -ApiToken $testApiToken -Permissions 'p1', 'p2', 'p3'
        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $Body -And $Body['permissions'] -eq 'p1,p2,p3' }
    }

    It 'Should allow to retrieve all properties' {
        Get-TeamViewerUser -ApiToken $testApiToken -PropertiesToLoad 'All'
        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $Body -And $Body['full_list'] -eq $true }
    }

    It 'Should allow to retrieve a minimal set of properties' {
        Get-TeamViewerUser -ApiToken $testApiToken -PropertiesToLoad 'Minimal'
        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $Body -And $Body['full_list'] -eq $null }
    }
}
