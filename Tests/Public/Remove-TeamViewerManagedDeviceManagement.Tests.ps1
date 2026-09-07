BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Remove-TeamViewerManagedDeviceManagement.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }

    $testAPIToken = [securestring]@{}
    $null = $testAPIToken
    $testDeviceId = 'c37e72b8-b78d-467f-923c-6083c13cf82f'
    $null = $testDeviceId

    Mock Get-TeamViewerAPIUri { '//unit.test' }
    Mock Invoke-TeamViewerRestMethod { }
}

Describe 'Remove-TeamViewerManagedDeviceManagement' {
    Context 'Parameter aliases' {
        It 'Should expose <Alias> as an alias of the <Param> parameter' -ForEach @(
            @{ Param = 'Device'; Alias = 'Id' }
            @{ Param = 'Device'; Alias = 'DeviceId' }
            @{ Param = 'Device'; Alias = 'ManagedDeviceId' }
            @{ Param = 'Device'; Alias = 'ManagedDevice' }
        ) {
            (Get-Command -Name Remove-TeamViewerManagedDeviceManagement).Parameters[$Param].Aliases | Should -Contain $Alias
        }
    }
    It 'Should call the correct API endpoint' {
        Remove-TeamViewerManagedDeviceManagement -APIToken $testAPIToken -DeviceId $testDeviceId

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $APIToken -eq $testAPIToken -and $Uri -eq "//unit.test/managed/devices/$testDeviceId" -and $Method -eq 'Delete' }
    }

    It 'Should accept ManagedDevice objects' {
        $testDeviceObj = @{ id = $testDeviceId } | ConvertTo-TeamViewerManagedDevice

        Remove-TeamViewerManagedDeviceManagement -APIToken $testAPIToken -Device $testDeviceObj

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $APIToken -eq $testAPIToken -and $Uri -eq "//unit.test/managed/devices/$testDeviceId" -and $Method -eq 'Delete' }
    }

    It 'Should accept pipeline input' {
        $testDeviceObj = @{ id = $testDeviceId } | ConvertTo-TeamViewerManagedDevice
        $testDeviceObj | Remove-TeamViewerManagedDeviceManagement -APIToken $testAPIToken

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $APIToken -eq $testAPIToken -and $Uri -eq "//unit.test/managed/devices/$testDeviceId" -and $Method -eq 'Delete' }
    }
}
