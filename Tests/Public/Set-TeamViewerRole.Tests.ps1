BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Set-TeamViewerRole.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }

    $testApiToken = [securestring]@{}
    $null = $testApiToken
    $mockArgs = @{}
    $testRoleName = 'Test Role'
    $null = $testRoleName
    $testPermissions = 'AllowGroupSharing', 'AssignBackupPolicies'
    $null = $testPermissions
    $testRoleId = '9b465ea2-2f75-4101-a057-58a81ed0e57b'
    $null = $testRoleId

    Mock Get-TeamViewerApiUri { '//unit.test' }
    Mock Invoke-TeamViewerRestMethod {
        $mockArgs.Body = $Body
        @{
            Name        = $testRoleName
            Permissions = @($testPermissions)
            RoleId      = $testRoleId

        }
    }
}

Describe 'Set-TeamViewerRole' {
    It 'Should call the correct API endpoint' {
        Set-TeamViewerRole -ApiToken $testApiToken -Name $testRoleName -RoleId $testRoleId

        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And `
                $Uri -eq '//unit.test/userroles' -And `
                $Method -eq 'Put'
        }
    }

    It 'Should include the given name in the request' {
        Set-TeamViewerRole -ApiToken $testApiToken -Name $testRoleName -RoleId $testRoleId

        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $body.Name | Should -Be $testRoleName
    }

    It 'Should include the given permissions in the request' {
        Set-TeamViewerRole -ApiToken $testApiToken -Name $testRoleName -Permissions $testPermissions -RoleId $testRoleId

        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $body.Permissions | Should -Be $testPermissions
    }

    # It 'Should return a Role object' {
    #Request doesn't return a response body
    # }

    It 'Should change role properties' {
        $TestNameChange = 'Test1234'
        $testPermissionsChange = 'ModifyConnections'
        Set-TeamViewerRole `
            -ApiToken $testApiToken `
            -Name $TestNameChange `
            -Permissions $testPermissionsChange `
            -RoleId $testRoleId
        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $body.Name | Should -Be 'Test1234'
        $body.Permissions | Should -Be 'ModifyConnections'

    }
}
