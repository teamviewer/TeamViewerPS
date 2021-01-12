BeforeAll {
    . "$PSScriptRoot/../../TeamViewerPS/Public/Remove-TeamViewerManagedDevice.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot/../../TeamViewerPS/Private/*.ps1") | `
        ForEach-Object { . $_.FullName }

    $testApiToken = [securestring]@{}
    $null = $testApiToken
    $testGroupId = '6878ab59-5b19-4c7f-9afc-c1c07b0bfb7c'
    $null = $testGroupId
    $testDeviceId = 'c37e72b8-b78d-467f-923c-6083c13cf82f'
    $null = $testDeviceId

    Mock Get-TeamViewerApiUri { '//unit.test' }
    Mock Invoke-TeamViewerRestMethod { }
}

Describe 'Remove-TeamViewerManagedDevice' {
    It 'Should call the correct API endpoint' {
        Remove-TeamViewerManagedDevice -ApiToken $testApiToken -DeviceId $testDeviceId -GroupId $testGroupId

        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And `
                $Uri -eq "//unit.test/managed/groups/$testGroupId/devices/$testDeviceId" -And `
                $Method -eq 'Delete' }
    }

    It 'Should accept ManagedGroup objects' {
        $testGroup = @{ id = $testGroupId } | ConvertTo-TeamViewerManagedGroup
        Remove-TeamViewerManagedDevice -ApiToken $testApiToken -DeviceId $testDeviceId -Group $testGroup

        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And `
                $Uri -eq "//unit.test/managed/groups/$testGroupId/devices/$testDeviceId" -And `
                $Method -eq 'Delete' }
    }

    It 'Should accept ManagedDevice objects' {
        $testDeviceObj = @{ id = $testDeviceId } | ConvertTo-TeamViewerManagedDevice
        Remove-TeamViewerManagedDevice -ApiToken $testApiToken -Device $testDeviceObj -GroupId $testGroupId

        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And `
                $Uri -eq "//unit.test/managed/groups/$testGroupId/devices/$testDeviceId" -And `
                $Method -eq 'Delete' }
    }

    It 'Should accept pipeline input' {
        $testDeviceObj = @{ id = $testDeviceId } | ConvertTo-TeamViewerManagedDevice
        $testDeviceObj | Remove-TeamViewerManagedDevice -ApiToken $testApiToken -GroupId $testGroupId

        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And `
                $Uri -eq "//unit.test/managed/groups/$testGroupId/devices/$testDeviceId" -And `
                $Method -eq 'Delete' }
    }
}
