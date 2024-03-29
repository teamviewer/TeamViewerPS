BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Remove-TeamViewerUserGroupFromRole.ps1"
    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | `
        ForEach-Object { . $_.FullName }

    $testApiToken = [securestring]@{}
    $null = $testApiToken
    $testUserGroup = 1234
    $null = $testUserGroup


    Mock Get-TeamViewerApiUri { '//unit.test' }
    $mockArgs = @{}
    Mock Invoke-TeamViewerRestMethod { $mockArgs.Body = $Body
        @{
            UserGroupId = $testUserGroup
        }
    }
}
Describe 'Remove-TeamViewerUserGroupFromRole' {

    It 'Should call the correct API endpoint' {
        Remove-TeamViewerUserGroupFromRole -ApiToken $testApiToken -UserGroup $testUserGroup

        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And `
                $Uri -eq '//unit.test/userroles/unassign/usergroup' -And `
                $Method -eq 'Post'
        }
    }

    It 'Should unassign the given user group from the user role' {
        Remove-TeamViewerUserGroupFromRole `
            -ApiToken $testApiToken `
            -UserGroup $testUserGroup
        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $body.UserGroupId | Should -HaveCount 1
        $body.UserGroupId | Should -Be $testUserGroup
    }
}
