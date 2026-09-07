BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Remove-TeamViewerManagedDevice.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }

    $testAPIToken = [securestring]@{}
    $null = $testAPIToken
    $testGroupId = '6878ab59-5b19-4c7f-9afc-c1c07b0bfb7c'
    $null = $testGroupId
    $testDeviceId = 'c37e72b8-b78d-467f-923c-6083c13cf82f'
    $null = $testDeviceId

    Mock Get-TeamViewerAPIUri { '//unit.test' }
    Mock Invoke-TeamViewerRestMethod { }
}

Describe 'Remove-TeamViewerManagedDevice' {
    Context 'Parameter aliases' {
        It 'Should expose <Alias> as an alias of the <Param> parameter' -ForEach @(
            @{ Param = 'Device'; Alias = 'Id' }
            @{ Param = 'Device'; Alias = 'DeviceId' }
            @{ Param = 'Device'; Alias = 'ManagedDeviceId' }
            @{ Param = 'Device'; Alias = 'ManagedDevice' }
            @{ Param = 'Group'; Alias = 'GroupId' }
            @{ Param = 'Group'; Alias = 'ManagedGroupId' }
            @{ Param = 'Group'; Alias = 'ManagedGroup' }
        ) {
            (Get-Command -Name Remove-TeamViewerManagedDevice).Parameters[$Param].Aliases | Should -Contain $Alias
        }
    }
    It 'Should call the correct API endpoint' {
        Remove-TeamViewerManagedDevice -APIToken $testAPIToken -DeviceId $testDeviceId -GroupId $testGroupId

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $APIToken -eq $testAPIToken -and $Uri -eq "//unit.test/managed/groups/$testGroupId/devices/$testDeviceId" -and $Method -eq 'Delete' }
    }

    It 'Should accept ManagedGroup objects' {
        $testGroup = @{ id = $testGroupId } | ConvertTo-TeamViewerManagedGroup

        Remove-TeamViewerManagedDevice -APIToken $testAPIToken -DeviceId $testDeviceId -Group $testGroup

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $APIToken -eq $testAPIToken -and $Uri -eq "//unit.test/managed/groups/$testGroupId/devices/$testDeviceId" -and $Method -eq 'Delete' }
    }

    It 'Should accept ManagedDevice objects' {
        $testDeviceObj = @{ id = $testDeviceId } | ConvertTo-TeamViewerManagedDevice

        Remove-TeamViewerManagedDevice -APIToken $testAPIToken -Device $testDeviceObj -GroupId $testGroupId

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $APIToken -eq $testAPIToken -and $Uri -eq "//unit.test/managed/groups/$testGroupId/devices/$testDeviceId" -and $Method -eq 'Delete' }
    }

    It 'Should accept pipeline input' {
        $testDeviceObj = @{ id = $testDeviceId } | ConvertTo-TeamViewerManagedDevice
        $testDeviceObj | Remove-TeamViewerManagedDevice -APIToken $testAPIToken -GroupId $testGroupId

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $APIToken -eq $testAPIToken -and $Uri -eq "//unit.test/managed/groups/$testGroupId/devices/$testDeviceId" -and $Method -eq 'Delete' }
    }
}
