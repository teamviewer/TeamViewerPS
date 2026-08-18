BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Add-TeamViewerUserToRole.ps1"
    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }

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
            UserIds    = @($testAccount)
            UserRoleId = $testRoleId
        }
    }
}
Describe 'Add-TeamViewerUserToRole' {
    It 'Should call the correct API endpoint' {
        Add-TeamViewerUserToRole -ApiToken $testApiToken -RoleId $testRoleId -Accounts $testAccount

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -and $Uri -eq '//unit.test/userroles/assign/account' -and $Method -eq 'Post'
        }
    }

    It 'Should assign the given account to the user role' {
        Add-TeamViewerUserToRole -ApiToken $testApiToken -RoleId $testRoleId -Accounts $testAccount
        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $Body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $Body.UserIds | Should -HaveCount 2

        foreach ($Id in $testAccount) {
            $Body.UserIds | Should -Contain $id
        }

        $Body.UserRoleId | Should -Be $testRoleId
    }

    It 'Should accept pipeline input' {
        $testAccount | Add-TeamViewerUserToRole -ApiToken $testApiToken -RoleId $testRoleId
        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $Body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $Body.UserIds | Should -HaveCount 2

        foreach ($Id in $testAccount) {
            $Body.UserIds | Should -Contain $id
        }

        $Body.UserRoleId | Should -Be $testRoleId
    }

    It 'Should batch pipeline input after 100 accounts' {
        $TestAccounts = 1..101 | ForEach-Object { "u$_" }

        $TestAccounts | Add-TeamViewerUserToRole -ApiToken $testApiToken -RoleId $testRoleId

        Should -Invoke Invoke-TeamViewerRestMethod -Times 2 -Scope It
    }

    It 'Should not invoke REST when WhatIf is used' {
        Add-TeamViewerUserToRole -ApiToken $testApiToken -RoleId $testRoleId -Accounts $testAccount -WhatIf

        Should -Invoke Invoke-TeamViewerRestMethod -Times 0 -Scope It
    }
}
