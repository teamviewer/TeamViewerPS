BeforeAll {
    . "$PSScriptRoot/../../Docs/Cmdlets/Public/Remove-TeamViewerManager.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot/../../Docs/Cmdlets/Private/*.ps1") | `
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
    Mock Invoke-TeamViewerRestMethod {}
}

Describe 'Remove-TeamViewerManager' {
    Context 'Group' {
        It 'Should call the correct API endpoint to remove managed group managers' {
            Remove-TeamViewerManager `
                -ApiToken $testApiToken `
                -GroupId $testGroupId `
                -ManagerId $testManagerId
            Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
                $ApiToken -eq $testApiToken -And `
                    $Uri -eq "//unit.test/managed/groups/$testGroupId/managers/$testManagerId" -And `
                    $Method -eq 'Delete' }
        }

        It 'Should accept group Manager objects' {
            $testManager = @{id = $testManagerId } | ConvertTo-TeamViewerManager -GroupId $testGroupId
            Remove-TeamViewerManager `
                -ApiToken $testApiToken `
                -Manager $testManager
            Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
                $ApiToken -eq $testApiToken -And `
                    $Uri -eq "//unit.test/managed/groups/$testGroupId/managers/$testManagerId" -And `
                    $Method -eq 'Delete' }
        }

        It 'Should accept pipeline objects' {
            $testManager = @{id = $testManagerId } | ConvertTo-TeamViewerManager -GroupId $testGroupId
            $testManager | Remove-TeamViewerManager -ApiToken $testApiToken
            Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
                $ApiToken -eq $testApiToken -And `
                    $Uri -eq "//unit.test/managed/groups/$testGroupId/managers/$testManagerId" -And `
                    $Method -eq 'Delete' }
        }

        It 'Should throw if Manager object and group are specified' {
            $testManager = @{id = $testManagerId } | ConvertTo-TeamViewerManager -GroupId $testGroupId
            { Remove-TeamViewerManager `
                    -ApiToken $testApiToken `
                    -Manager $testManager `
                    -GroupId $testGroupId
            } | Should -Throw
        }
    }

    Context 'Device' {
        It 'Should call the correct API endpoint to remove managed device managers' {
            Remove-TeamViewerManager `
                -ApiToken $testApiToken `
                -DeviceId $testDeviceId `
                -ManagerId $testManagerId
            Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
                $ApiToken -eq $testApiToken -And `
                    $Uri -eq "//unit.test/managed/devices/$testDeviceId/managers/$testManagerId" -And `
                    $Method -eq 'Delete' }
        }

        It 'Should accept device Manager objects' {
            $testManager = @{id = $testManagerId } | ConvertTo-TeamViewerManager -DeviceId $testDeviceId
            Remove-TeamViewerManager `
                -ApiToken $testApiToken `
                -Manager $testManager
            Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
                $ApiToken -eq $testApiToken -And `
                    $Uri -eq "//unit.test/managed/devices/$testDeviceId/managers/$testManagerId" -And `
                    $Method -eq 'Delete' }
        }

        It 'Should accept pipeline objects' {
            $testManager = @{id = $testManagerId } | ConvertTo-TeamViewerManager -DeviceId $testDeviceId
            $testManager | Remove-TeamViewerManager -ApiToken $testApiToken
            Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
                $ApiToken -eq $testApiToken -And `
                    $Uri -eq "//unit.test/managed/devices/$testDeviceId/managers/$testManagerId" -And `
                    $Method -eq 'Delete' }
        }

        It 'Should throw if Manager object and device are specified' {
            $testManager = @{id = $testManagerId } | ConvertTo-TeamViewerManager -DeviceId $testDeviceId
            { Remove-TeamViewerManager `
                    -ApiToken $testApiToken `
                    -Manager $testManager `
                    -DeviceId $testDeviceId
            } | Should -Throw
        }
    }

    It 'Should throw if no Manager object and no device or group are specified' {
        { Set-TeamViewerManagedGroupManager `
                -ApiToken $testApiToken `
                -ManagerId $testManagerId
        } | Should -Throw
    }
}
