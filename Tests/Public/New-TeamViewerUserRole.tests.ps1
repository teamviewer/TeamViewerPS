BeforeAll {
    . "$PSScriptRoot/../../Docs/Cmdlets/Public/New-TeamViewerUserRole.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot/../../Docs/Cmdlets/Private/*.ps1") | ForEach-Object { . $_.FullName }

    $testApiToken = [securestring]@{}
    $null = $testApiToken
    $mockArgs = @{}
    $testUserRoleName = 'Test Role'
    $testPermissions = 'AllowGroupSharing', 'AssignBackupPolicies'

    Mock Get-TeamViewerApiUri { '//unit.test' }
    Mock Invoke-TeamViewerRestMethod {
        $mockArgs.Body = $Body
        @{
            Role = @{
                Name        = $testUserRoleName
                Id          = '9b465ea2-2f75-4101-a057-58a81ed0e57b'
                Permissions = $testPermissions

            }
        }
    }
}

Describe 'New-TeamViewerUserRole' {
    It 'Should call the correct API endpoint' {
        New-TeamViewerUserRole -ApiToken $testApiToken -Name $testUserRoleName

        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And `
                $Uri -eq '//unit.test/userroles' -And `
                $Method -eq 'Post'
        }
    }

    It 'Should include the given name in the request' {
        New-TeamViewerUserRole -ApiToken $testApiToken -Name $testUserRoleName

        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $body.Name | Should -Be $testUserRoleName
    }

    It 'Should include the given permissions in the request' {
        New-TeamViewerUserRole -ApiToken $testApiToken -Name $testUserRoleName -Permissions $testPermissions

        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $body.Permissions | Should -Be $testPermissions
    }

    It 'Should return a UserRole object' {
        $result = New-TeamViewerUserRole -ApiToken $testApiToken -Name $testUserRoleName -Permissions $testPermissions
        $result | Should -Not -BeNullOrEmpty
        $result | Should -BeOfType [PSObject]
        $result.PSObject.TypeNames | Should -Contain 'TeamViewerPS.UserRole'
        $result.RoleName | Should -Be $testUserRoleName
        foreach ($Rule in $result.Permissions) {
            $result.Permissions.$Rule | Should -Be $testPermissions
        }
    }
}
