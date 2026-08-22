BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Remove-TeamViewerDevice.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }

    $testApiToken = [securestring]@{}
    $null = $testApiToken

    Mock Get-TeamViewerApiUri { '//unit.test' }
    Mock Invoke-TeamViewerRestMethod { }
}

Describe 'Remove-TeamViewerDevice' {
    It 'Should call the correct API endpoint' {
        Remove-TeamViewerDevice -ApiToken $testApiToken -Id 'd1234'

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -and $Uri -eq '//unit.test/devices/d1234' -and $Method -eq 'Delete' }
    }

    It 'Should accept Device objects' {
        $testDeviceObj = @{ device_id = 'd1234' } | ConvertTo-TeamViewerDevice

        Remove-TeamViewerDevice -ApiToken $testApiToken -Device $testDeviceObj

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -and $Uri -eq '//unit.test/devices/d1234' -and $Method -eq 'Delete' }
    }

    It 'Should accept pipeline input' {
        $testDeviceObj = @{ device_id = 'd1234' } | ConvertTo-TeamViewerDevice
        $testDeviceObj | Remove-TeamViewerDevice -ApiToken $testApiToken

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -and $Uri -eq '//unit.test/devices/d1234' -and $Method -eq 'Delete' }
    }
}
