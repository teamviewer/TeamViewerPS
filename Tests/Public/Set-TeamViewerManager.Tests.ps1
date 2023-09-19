BeforeAll {
    . "$PSScriptRoot/../../docs/Cmdlets/Public/Set-TeamViewerManager.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot/../../docs/Cmdlets/Private/*.ps1") | `
        ForEach-Object { . $_.FullName }

    $testApiToken = [securestring]@{}
    $null = $testApiToken
    $testGroupId = '9e5617cb-2b20-4da2-bca4-c1bda85b29ab'
    $null = $testGroupId
    $testDeviceId = 'c37e72b8-b78d-467f-923c-6083c13cf82f'
    $null = $testDeviceId
    $testManagerId = 'f47002d9-0c26-49e6-98cd-c99fd96beff5'
    $null = $testManagerId

    Mock Get-TeamViewerApiUri { '//unit.test' }
    $mockArgs = @{}
    Mock Invoke-TeamViewerRestMethod { $mockArgs.Body = $Body }
}

Describe 'Set-TeamViewerManager' {
    Context 'Group' {
        It 'Should call the correct API endpoint to update managed group managers' {
            Set-TeamViewerManager `
                -ApiToken $testApiToken `
                -GroupId $testGroupId `
                -ManagerId $testManagerId `
                -Permissions 'ManagerAdministration', 'EasyAccess'
            Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
                $ApiToken -eq $testApiToken -And `
                    $Uri -eq "//unit.test/managed/groups/$testGroupId/managers/$testManagerId" -And `
                    $Method -eq 'Put' }
        }

        It 'Should accept Manager objects' {
            $testManager = @{id = $testManagerId } | ConvertTo-TeamViewerManager -GroupId $testGroupId
            Set-TeamViewerManager `
                -ApiToken $testApiToken `
                -Manager $testManager `
                -Permissions 'ManagerAdministration', 'EasyAccess'
            Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
                $ApiToken -eq $testApiToken -And `
                    $Uri -eq "//unit.test/managed/groups/$testGroupId/managers/$testManagerId" -And `
                    $Method -eq 'Put' }
        }

        It 'Should throw if Manager object and group are specified' {
            $testManager = @{id = $testManagerId } | ConvertTo-TeamViewerManager -GroupId $testGroupId
            { Set-TeamViewerManager `
                    -ApiToken $testApiToken `
                    -Manager $testManager `
                    -GroupId $testGroupId `
                    -Permissions 'ManagerAdministration', 'EasyAccess'
            } | Should -Throw
        }
    }

    Context 'Device' {
        It 'Should call the correct API endpoint to update managed device managers' {
            Set-TeamViewerManager `
                -ApiToken $testApiToken `
                -DeviceId $testDeviceId `
                -ManagerId $testManagerId `
                -Permissions 'ManagerAdministration', 'EasyAccess'
            Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
                $ApiToken -eq $testApiToken -And `
                    $Uri -eq "//unit.test/managed/devices/$testDeviceId/managers/$testManagerId" -And `
                    $Method -eq 'Put' }
        }

        It 'Should accept Manager objects' {
            $testManager = @{id = $testManagerId } | ConvertTo-TeamViewerManager -DeviceId $testDeviceId
            Set-TeamViewerManager `
                -ApiToken $testApiToken `
                -Manager $testManager `
                -Permissions 'ManagerAdministration', 'EasyAccess'
            Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
                $ApiToken -eq $testApiToken -And `
                    $Uri -eq "//unit.test/managed/devices/$testDeviceId/managers/$testManagerId" -And `
                    $Method -eq 'Put' }
        }

        It 'Should throw if Manager object and device are specified' {
            $testManager = @{id = $testManagerId } | ConvertTo-TeamViewerManager -DeviceId $testDeviceId
            { Set-TeamViewerManager `
                    -ApiToken $testApiToken `
                    -Manager $testManager `
                    -DeviceId $testDeviceId `
                    -Permissions 'ManagerAdministration', 'EasyAccess'
            } | Should -Throw
        }
    }

    It 'Should update the manager permissions' {
        Set-TeamViewerManager `
            -ApiToken $testApiToken `
            -GroupId $testGroupId `
            -ManagerId $testManagerId `
            -Permissions 'ManagerAdministration', 'EasyAccess'
        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $body.permissions | Should -HaveCount 2
        $body.permissions | Should -Contain 'ManagerAdministration'
        $body.permissions | Should -Contain 'EasyAccess'
    }

    It 'Should accept an empty permissions list' {
        Set-TeamViewerManager `
            -ApiToken $testApiToken `
            -GroupId $testGroupId `
            -ManagerId $testManagerId `
            -Permissions @()
        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $body.permissions | Should -HaveCount 0
    }

    It 'Should accept a properties hashtable as input' {
        Set-TeamViewerManager `
            -ApiToken $testApiToken `
            -GroupId $testGroupId `
            -ManagerId $testManagerId `
            -Property @{permissions = @('DeviceAdministration', 'PolicyAdministration') }
        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $body.permissions | Should -HaveCount 2
        $body.permissions | Should -Contain 'DeviceAdministration'
        $body.permissions | Should -Contain 'PolicyAdministration'
    }

    It 'Should throw if the properties hashtable does not change the manager' {
        { Set-TeamViewerManager `
                -ApiToken $testApiToken `
                -GroupId $testGroupId `
                -ManagerId $testManagerId `
                -Property @{ foo = 'bar' }
        } | Should -Throw
    }

    It 'Should accept pipeline objects' {
        $testManager = @{id = $testManagerId } | ConvertTo-TeamViewerManager -GroupId $testGroupId
        $testManager | Set-TeamViewerManager `
            -ApiToken $testApiToken `
            -Permissions 'ManagerAdministration', 'EasyAccess'
        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And `
                $Uri -eq "//unit.test/managed/groups/$testGroupId/managers/$testManagerId" -And `
                $Method -eq 'Put' }
    }

    It 'Should throw if no Manager object and no group or device are specified' {
        { Set-TeamViewerManager `
                -ApiToken $testApiToken `
                -ManagerId $testManagerId `
                -Permissions 'ManagerAdministration', 'EasyAccess'
        } | Should -Throw
    }
}
