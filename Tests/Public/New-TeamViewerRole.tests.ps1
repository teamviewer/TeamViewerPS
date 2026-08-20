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

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -and $Uri -eq '//unit.test/userroles' -and $Method -eq 'Post'
        }
    }

    It 'Should include the given name in the request' {
        New-TeamViewerRole -ApiToken $testApiToken -Name $testRoleName

        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $Body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $Body.Name | Should -Be $testRoleName
    }

    It 'Should include the given permissions in the request' {
        New-TeamViewerRole -ApiToken $testApiToken -Name $testRoleName -Permissions $testPermissions

        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $Body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $Body.Permissions | Should -Be $testPermissions
    }

    It 'Should return a Role object' {
        $Result = New-TeamViewerRole -ApiToken $testApiToken -Name $testRoleName -Permissions $testPermissions
        $Result | Should -Not -BeNullOrEmpty
        $Result | Should -BeOfType ([pscustomobject])
        $Result.PSObject.TypeNames | Should -Contain 'TeamViewerPS.Role'
        $Result.RoleName | Should -Be $testRoleName

        foreach ($Rule in $Result.Permissions) {
            $Result.Permissions.$Rule | Should -Be $testPermissions
        }
    }

    It 'Should not invoke REST when WhatIf is used' {
        New-TeamViewerRole -ApiToken $testApiToken -Name $testRoleName -WhatIf

        Should -Invoke Invoke-TeamViewerRestMethod -Times 0 -Scope It
    }
}
