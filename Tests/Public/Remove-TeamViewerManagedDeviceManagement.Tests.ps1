BeforeAll {
    . "$PSScriptRoot/../../docs/Cmdlets/Public/Remove-TeamViewerManagedDeviceManagement.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot/../../docs/Cmdlets/Private/*.ps1") | `
        ForEach-Object { . $_.FullName }

    $testApiToken = [securestring]@{}
    $null = $testApiToken
    $testDeviceId = 'c37e72b8-b78d-467f-923c-6083c13cf82f'
    $null = $testDeviceId

    Mock Get-TeamViewerApiUri { '//unit.test' }
    Mock Invoke-TeamViewerRestMethod { }
}

Describe 'Remove-TeamViewerManagedDeviceManagement' {
    It 'Should call the correct API endpoint' {
        Remove-TeamViewerManagedDeviceManagement -ApiToken $testApiToken -DeviceId $testDeviceId

        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And `
                $Uri -eq "//unit.test/managed/devices/$testDeviceId" -And `
                $Method -eq 'Delete' }
    }

    It 'Should accept ManagedDevice objects' {
        $testDeviceObj = @{ id = $testDeviceId } | ConvertTo-TeamViewerManagedDevice
        Remove-TeamViewerManagedDeviceManagement -ApiToken $testApiToken -Device $testDeviceObj

        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And `
                $Uri -eq "//unit.test/managed/devices/$testDeviceId" -And `
                $Method -eq 'Delete' }
    }

    It 'Should accept pipeline input' {
        $testDeviceObj = @{ id = $testDeviceId } | ConvertTo-TeamViewerManagedDevice
        $testDeviceObj | Remove-TeamViewerManagedDeviceManagement -ApiToken $testApiToken

        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And `
                $Uri -eq "//unit.test/managed/devices/$testDeviceId" -And `
                $Method -eq 'Delete' }
    }
}
