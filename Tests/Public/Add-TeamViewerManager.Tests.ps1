BeforeAll {
    . "$PSScriptRoot/../../docs/Cmdlets/Public/Add-TeamViewerManager.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot/../../docs/Cmdlets/Private/*.ps1") | `
        ForEach-Object { . $_.FullName }

    $testApiToken = [securestring]@{}
    $null = $testApiToken
    $testGroupId = '9e5617cb-2b20-4da2-bca4-c1bda85b29ab'
    $null = $testGroupId
    $testDeviceId = 'c37e72b8-b78d-467f-923c-6083c13cf82f'
    $null = $testDeviceId
    $testAccountId = 'u123456'
    $null = $testAccountId
    $testManagerId = '07f88e56-fe7c-4965-8f51-c8fb86f9cd0e'
    $null = $testManagerId

    Mock Get-TeamViewerApiUri { '//unit.test' }
    $mockArgs = @{}
    Mock Invoke-TeamViewerRestMethod { $mockArgs.Body = $Body }
}

Describe 'Add-TeamViewerManager' {
    Context 'Group' {
        It 'Should call the correct API endpoint to add managed group managers' {
            Add-TeamViewerManager `
                -ApiToken $testApiToken `
                -GroupId $testGroupId `
                -AccountId $testAccountId
            Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
                $ApiToken -eq $testApiToken -And `
                    $Uri -eq "//unit.test/managed/groups/$testGroupId/managers" -And `
                    $Method -eq 'Post' }
        }

        It 'Should add the manager to the group' {
            Add-TeamViewerManager `
                -ApiToken $testApiToken `
                -GroupId $testGroupId `
                -AccountId $testAccountId `
                -Permissions 'EasyAccess', 'ManagerAdministration'
            $mockArgs.Body | Should -Not -BeNullOrEmpty
            $body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
            $body.accountId | Should -Be '123456'
            $body.permissions | Should -HaveCount 2
            $body.permissions | Should -Contain 'EasyAccess'
            $body.permissions | Should -Contain 'ManagerAdministration'
        }

        It 'Should accept group objects as input' {
            $groupObj = @{id = $testGroupId } | ConvertTo-TeamViewerManagedGroup
            Add-TeamViewerManager `
                -ApiToken $testApiToken `
                -Group $groupObj `
                -AccountId $testAccountId
            Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
                $ApiToken -eq $testApiToken -And `
                    $Uri -eq "//unit.test/managed/groups/$testGroupId/managers" -And `
                    $Method -eq 'Post' }
        }
    }

    Context 'Device' {
        It 'Should call the correct API endpoint to add managed device managers' {
            Add-TeamViewerManager `
                -ApiToken $testApiToken `
                -DeviceId $testDeviceId `
                -AccountId $testAccountId
            Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
                $ApiToken -eq $testApiToken -And `
                    $Uri -eq "//unit.test/managed/devices/$testDeviceId/managers" -And `
                    $Method -eq 'Post' }
        }

        It 'Should add the manager to the device' {
            Add-TeamViewerManager `
                -ApiToken $testApiToken `
                -DeviceId $testDeviceId `
                -AccountId $testAccountId `
                -Permissions 'EasyAccess', 'ManagerAdministration'
            $mockArgs.Body | Should -Not -BeNullOrEmpty
            $body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
            $body.accountId | Should -Be '123456'
            $body.permissions | Should -HaveCount 2
            $body.permissions | Should -Contain 'EasyAccess'
            $body.permissions | Should -Contain 'ManagerAdministration'
        }

        It 'Should accept device objects as input' {
            $deviceObj = @{id = $testDeviceId } | ConvertTo-TeamViewerManagedDevice
            Add-TeamViewerManager `
                -ApiToken $testApiToken `
                -Device $deviceObj `
                -AccountId $testAccountId
            Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
                $ApiToken -eq $testApiToken -And `
                    $Uri -eq "//unit.test/managed/devices/$testDeviceId/managers" -And `
                    $Method -eq 'Post' }
        }
    }

    It 'Should accept manager ID as input' {
        Add-TeamViewerManager `
            -ApiToken $testApiToken `
            -GroupId $testGroupId `
            -ManagerId $testManagerId
        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $body.id | Should -Be $testManagerId
    }

    It 'Should accept manager objects as input' {
        $managerObj = @{id = $testManagerId } | ConvertTo-TeamViewerManager -DeviceId (New-Guid)
        Add-TeamViewerManager `
            -ApiToken $testApiToken `
            -GroupId $testGroupId `
            -Manager $managerObj
        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $body.id | Should -Be $testManagerId
    }

    It 'Should accept a user object as input' {
        $userObj = @{id = $testAccountId } | ConvertTo-TeamViewerUser
        Add-TeamViewerManager `
            -ApiToken $testApiToken `
            -GroupId $testGroupId `
            -User $userObj
        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $body.accountId | Should -Be 123456
    }

    It 'Should send a JSON array' {
        Add-TeamViewerManager `
            -ApiToken $testApiToken `
            -GroupId $testGroupId `
            -AccountId $testAccountId
        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $bodyText = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body)
        $bodyText[0] | Should -Be '['
        $bodyText[$bodyText.Length - 1] | Should -Be ']'
    }
}
