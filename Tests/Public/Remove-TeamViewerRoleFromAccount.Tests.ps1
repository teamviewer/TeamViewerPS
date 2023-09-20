BeforeAll {
    . "$PSScriptRoot/../../docs/Cmdlets/Public/Remove-TeamViewerRoleFromAccount.ps1"
    @(Get-ChildItem -Path "$PSScriptRoot/../../docs/Cmdlets/Private/*.ps1") | `
        ForEach-Object { . $_.FullName }

    $testApiToken = [securestring]@{}
    $null = $testApiToken
    $testAccount = @('u123', 'u124')
    $null = $testAccount
    $testUserRoleId = '9b465ea2-2f75-4101-a057-58a81ed0e57b'
    $null = $testUserRoleId

    Mock Get-TeamViewerApiUri { '//unit.test' }
    $mockArgs = @{}
    Mock Invoke-TeamViewerRestMethod { $mockArgs.Body = $Body
        @{
            UserIds    = @($testAccount)
            UserRoleId = $testUserRoleId
        }
    }
}
Describe 'Remove-TeamViewerRoleFromAccount' {

    It 'Should call the correct API endpoint' {
        Remove-TeamViewerRoleFromAccount -ApiToken $testApiToken -UserRoleId $testUserRoleId -Accounts $testAccount

        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And `
                $Uri -eq '//unit.test/userroles/unassign/account' -And `
                $Method -eq 'Post'
        }
    }

    It 'Should unassign the given account from the user role' {
        Remove-TeamViewerRoleFromAccount `
            -ApiToken $testApiToken `
            -UserRoleId $testUserRoleId `
            -Accounts $testAccount
        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $body.UserIds | Should -HaveCount 2
        foreach ($id in $testAccount) {
            $body.UserIds | Should -Contain $id
        }
        $body.UserRoleId | Should -Be $testUserRoleId
    }

    It 'Should accept pipeline input' {
        $testAccount | Remove-TeamViewerRoleFromAccount `
            -ApiToken $testApiToken `
            -UserRoleId $testUserRoleId
        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $body.UserIds | Should -HaveCount 2
        foreach ($id in $testAccount) {
            $body.UserIds | Should -Contain $id
        }
        $body.UserRoleId | Should -Be $testUserRoleId
    }
}
