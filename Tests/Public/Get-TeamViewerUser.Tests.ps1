BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Get-TeamViewerUser.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }

    $testAPIToken = [securestring]@{}
    $null = $testAPIToken

    Mock Get-TeamViewerAPIUri { '//unit.test' }
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
        Get-TeamViewerUser -APIToken $testAPIToken

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $APIToken -eq $testAPIToken -and $Uri -eq '//unit.test/users' -and $Method -eq 'Get' }
    }

    It 'Should call the correct API endpoint for single user' {
        Get-TeamViewerUser -APIToken $testAPIToken -User 'u1234'

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $APIToken -eq $testAPIToken -and $Uri -eq '//unit.test/users/u1234' -and $Method -eq 'Get' }
    }

    It 'Should return User objects' {
        $Result = Get-TeamViewerUser -APIToken $testAPIToken
        $Result | Should -HaveCount 3
        $Result[0].PSObject.TypeNames | Should -Contain 'TeamViewerPS.User'
    }

    It 'Should allow to filter by name' {
        Get-TeamViewerUser -APIToken $testAPIToken -Name 'TestName'

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $Body -and $Body['name'] -eq 'TestName' }
    }

    It 'Should allow to filter by emails' {
        Get-TeamViewerUser -APIToken $testAPIToken -Email 'user1@unit.test', 'user2@unit.test'

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $Body -and $Body['email'] -eq 'user1@unit.test,user2@unit.test' }
    }

    It 'Should allow to filter by permissions' {
        Get-TeamViewerUser -APIToken $testAPIToken -Permissions 'p1', 'p2', 'p3'

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $Body -and $Body['permissions'] -eq 'p1,p2,p3' }
    }

    It 'Should allow to retrieve all properties' {
        Get-TeamViewerUser -APIToken $testAPIToken -Properties 'All'

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $Body -and $Body['full_list'] -eq $true }
    }

    It 'Should allow to retrieve a minimal set of properties' {
        Get-TeamViewerUser -APIToken $testAPIToken -Properties 'Minimal'

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $Body -and $Body['full_list'] -eq $null }
    }
}
