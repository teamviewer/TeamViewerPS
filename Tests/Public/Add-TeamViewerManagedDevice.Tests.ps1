BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Add-TeamViewerManagedDevice.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }

    $testAPIToken = [securestring]@{}
    $null = $testAPIToken
    $testGroupId = '9e5617cb-2b20-4da2-bca4-c1bda85b29ab'
    $null = $testGroupId
    $testDeviceId = 'c37e72b8-b78d-467f-923c-6083c13cf82f'
    $null = $testDeviceId

    Mock Get-TeamViewerAPIUri { '//unit.test' }
    $mockArgs = @{}
    Mock Invoke-TeamViewerRestMethod { $mockArgs.Body = $Body }
}

Describe 'Add-TeamViewerManagedDevice' {
    Context 'Parameter aliases' {
        It 'Should expose <Alias> as an alias of the <Param> parameter' -ForEach @(
            @{ Param = 'Device'; Alias = 'DeviceId' }
            @{ Param = 'Device'; Alias = 'ManagedDeviceId' }
            @{ Param = 'Device'; Alias = 'ManagedDevice' }
            @{ Param = 'Group'; Alias = 'GroupId' }
            @{ Param = 'Group'; Alias = 'ManagedGroupId' }
            @{ Param = 'Group'; Alias = 'ManagedGroup' }
        ) {
            (Get-Command -Name Add-TeamViewerManagedDevice).Parameters[$Param].Aliases | Should -Contain $Alias
        }
    }
    It 'Should call the correct API endpoint to add managed group devices' {
        Add-TeamViewerManagedDevice `
            -APIToken $testAPIToken `
            -GroupId $testGroupId `
            -DeviceId $testDeviceId

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $APIToken -eq $testAPIToken -and $Uri -eq "//unit.test/managed/groups/$testGroupId/devices" -and $Method -eq 'Post' }
    }

    It 'Should add the device to the group' {
        Add-TeamViewerManagedDevice -APIToken $testAPIToken -GroupId $testGroupId -DeviceId $testDeviceId

        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $Body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $Body.id | Should -Be $testDeviceId
    }

    It 'Should accept group objects as input' {
        $groupObj = @{id = $testGroupId } | ConvertTo-TeamViewerManagedGroup

        Add-TeamViewerManagedDevice `
            -APIToken $testAPIToken `
            -Group $groupObj `
            -DeviceId $testDeviceId

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $APIToken -eq $testAPIToken -and $Uri -eq "//unit.test/managed/groups/$testGroupId/devices" -and $Method -eq 'Post' }
    }
}
