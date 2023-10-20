BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\New-TeamViewerRole.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }

    $testApiToken = [securestring]@{}
    $null = $testApiToken
    $mockArgs = @{}
    $testRoleName = 'Test Role'
    $testPermissions = 'AllowGroupSharing', 'AssignBackupPolicies'

    Mock Get-TeamViewerApiUri { '//unit.test' }
    Mock Invoke-TeamViewerRestMethod {
        $mockArgs.Body = $Body
        @{
            Role = @{
                Name        = $testRoleName
                Id          = '9b465ea2-2f75-4101-a057-58a81ed0e57b'
                Permissions = $testPermissions

            }
        }
    }
}

Describe 'New-TeamViewerRole' {
    It 'Should call the correct API endpoint' {
        New-TeamViewerRole -ApiToken $testApiToken -Name $testRoleName

        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And `
                $Uri -eq '//unit.test/userroles' -And `
                $Method -eq 'Post'
        }
    }

    It 'Should include the given name in the request' {
        New-TeamViewerRole -ApiToken $testApiToken -Name $testRoleName

        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $body.Name | Should -Be $testRoleName
    }

    It 'Should include the given permissions in the request' {
        New-TeamViewerRole -ApiToken $testApiToken -Name $testRoleName -Permissions $testPermissions

        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $body.Permissions | Should -Be $testPermissions
    }

    It 'Should return a Role object' {
        $result = New-TeamViewerRole -ApiToken $testApiToken -Name $testRoleName -Permissions $testPermissions
        $result | Should -Not -BeNullOrEmpty
        $result | Should -BeOfType [PSObject]
        $result.PSObject.TypeNames | Should -Contain 'TeamViewerPS.Role'
        $result.RoleName | Should -Be $testRoleName
        foreach ($Rule in $result.Permissions) {
            $result.Permissions.$Rule | Should -Be $testPermissions
        }
    }
}
