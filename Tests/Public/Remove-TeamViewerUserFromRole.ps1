BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Remove-TeamViewerUserFromRole.ps1"
    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | `
        ForEach-Object { . $_.FullName }

    $testApiToken = [securestring]@{}
    $null = $testApiToken
    $testAccount = @('u123', 'u124')
    $null = $testAccount
    $testRoleId = '9b465ea2-2f75-4101-a057-58a81ed0e57b'
    $null = $testRoleId

    Mock Get-TeamViewerApiUri { '//unit.test' }
    $mockArgs = @{}
    Mock Invoke-TeamViewerRestMethod { $mockArgs.Body = $Body
        @{
            UserIds = @($testAccount)
            RoleId  = $testRoleId
        }
    }
}
Describe 'Remove-TeamViewerUserFromRole' {

    It 'Should call the correct API endpoint' {
        Remove-TeamViewerUserFromRole -ApiToken $testApiToken -RoleId $testRoleId -Accounts $testAccount

        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And `
                $Uri -eq '//unit.test/userroles/unassign/account' -And `
                $Method -eq 'Post'
        }
    }

    It 'Should unassign the given account from the user role' {
        Remove-TeamViewerUserFromRole `
            -ApiToken $testApiToken `
            -RoleId $testRoleId `
            -Accounts $testAccount
        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $body.UserIds | Should -HaveCount 2
        foreach ($id in $testAccount) {
            $body.UserIds | Should -Contain $id
        }
        $body.RoleId | Should -Be $testRoleId
    }

    It 'Should accept pipeline input' {
        $testAccount | Remove-TeamViewerUserFromRole `
            -ApiToken $testApiToken `
            -RoleId $testRoleId
        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $body.UserIds | Should -HaveCount 2
        foreach ($id in $testAccount) {
            $body.UserIds | Should -Contain $id
        }
        $body.RoleId | Should -Be $testRoleId
    }
}
