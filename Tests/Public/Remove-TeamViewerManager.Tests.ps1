BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Remove-TeamViewerManager.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }

    $testAPIToken = [securestring]@{}
    $null = $testAPIToken
    $testGroupId = '9e5617cb-2b20-4da2-bca4-c1bda85b29ab'
    $null = $testGroupId
    $testDeviceId = 'c37e72b8-b78d-467f-923c-6083c13cf82f'
    $null = $testDeviceId
    $testManagerId = 'f47002d9-0c26-49e6-98cd-c99fd96beff5'
    $null = $testManagerId

    Mock Get-TeamViewerAPIUri { '//unit.test' }
    Mock Invoke-TeamViewerRestMethod {}
}

Describe 'Remove-TeamViewerManager' {
    Context 'Parameter aliases' {
        It 'Should expose <Alias> as an alias of the <Param> parameter' -ForEach @(
            @{ Param = 'Device'; Alias = 'DeviceId' }
            @{ Param = 'Device'; Alias = 'ManagedDeviceId' }
            @{ Param = 'Device'; Alias = 'ManagedDevice' }
            @{ Param = 'Group'; Alias = 'GroupId' }
            @{ Param = 'Group'; Alias = 'ManagedGroupId' }
            @{ Param = 'Group'; Alias = 'ManagedGroup' }
        ) {
            (Get-Command -Name Remove-TeamViewerManager).Parameters[$Param].Aliases | Should -Contain $Alias
        }
    }
    Context 'Group' {
        It 'Should call the correct API endpoint to remove managed group managers' {
            Remove-TeamViewerManager -APIToken $testAPIToken -GroupId $testGroupId -ManagerId $testManagerId

            Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
                $APIToken -eq $testAPIToken -and $Uri -eq "//unit.test/managed/groups/$testGroupId/managers/$testManagerId" -and $Method -eq 'Delete' }
        }

        It 'Should accept group Manager objects' {
            $testManager = @{id = $testManagerId } | ConvertTo-TeamViewerManager -Group $testGroupId

            Remove-TeamViewerManager -APIToken $testAPIToken -Manager $testManager
            Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
                $APIToken -eq $testAPIToken -and $Uri -eq "//unit.test/managed/groups/$testGroupId/managers/$testManagerId" -and $Method -eq 'Delete' }
        }

        It 'Should accept pipeline objects' {
            $testManager = @{id = $testManagerId } | ConvertTo-TeamViewerManager -Group $testGroupId
            $testManager | Remove-TeamViewerManager -APIToken $testAPIToken

            Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
                $APIToken -eq $testAPIToken -and $Uri -eq "//unit.test/managed/groups/$testGroupId/managers/$testManagerId" -and $Method -eq 'Delete' }
        }

        It 'Should throw if Manager object and group are specified' {
            $testManager = @{id = $testManagerId } | ConvertTo-TeamViewerManager -Group $testGroupId
            { Remove-TeamViewerManager -APIToken $testAPIToken -Manager $testManager -Group $testGroupId
            } | Should -Throw
        }
    }

    Context 'Device' {
        It 'Should call the correct API endpoint to remove managed device managers' {
            Remove-TeamViewerManager -APIToken $testAPIToken -DeviceId $testDeviceId -ManagerId $testManagerId
            Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
                $APIToken -eq $testAPIToken -and $Uri -eq "//unit.test/managed/devices/$testDeviceId/managers/$testManagerId" -and $Method -eq 'Delete' }
        }

        It 'Should accept device Manager objects' {
            $testManager = @{id = $testManagerId } | ConvertTo-TeamViewerManager -Device $testDeviceId
            Remove-TeamViewerManager -APIToken $testAPIToken -Manager $testManager

            Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
                $APIToken -eq $testAPIToken -and $Uri -eq "//unit.test/managed/devices/$testDeviceId/managers/$testManagerId" -and $Method -eq 'Delete' }
        }

        It 'Should accept pipeline objects' {
            $testManager = @{id = $testManagerId } | ConvertTo-TeamViewerManager -Device $testDeviceId
            $testManager | Remove-TeamViewerManager -APIToken $testAPIToken

            Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
                $APIToken -eq $testAPIToken -and $Uri -eq "//unit.test/managed/devices/$testDeviceId/managers/$testManagerId" -and $Method -eq 'Delete' }
        }

        It 'Should throw if Manager object and device are specified' {
            $testManager = @{id = $testManagerId } | ConvertTo-TeamViewerManager -Device $testDeviceId

            { Remove-TeamViewerManager -APIToken $testAPIToken -Manager $testManager -Device $testDeviceId
            } | Should -Throw
        }
    }

    It 'Should throw if no Manager object and no device or group are specified' {
        { Remove-TeamViewerManager -APIToken $testAPIToken -ManagerId $testManagerId } | Should -Throw
    }
}
