BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Remove-TeamViewerDevice.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }

    $testAPIToken = [securestring]@{}
    $null = $testAPIToken

    Mock Get-TeamViewerAPIUri { '//unit.test' }
    Mock Invoke-TeamViewerRestMethod { }
}

Describe 'Remove-TeamViewerDevice' {
    It 'Should call the correct API endpoint' {
        Remove-TeamViewerDevice -APIToken $testAPIToken -Id 'd1234'

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $APIToken -eq $testAPIToken -and $Uri -eq '//unit.test/devices/d1234' -and $Method -eq 'Delete' }
    }

    It 'Should accept Device objects' {
        $testDeviceObj = @{ device_id = 'd1234' } | ConvertTo-TeamViewerDevice

        Remove-TeamViewerDevice -APIToken $testAPIToken -Device $testDeviceObj

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $APIToken -eq $testAPIToken -and $Uri -eq '//unit.test/devices/d1234' -and $Method -eq 'Delete' }
    }

    It 'Should accept pipeline input' {
        $testDeviceObj = @{ device_id = 'd1234' } | ConvertTo-TeamViewerDevice
        $testDeviceObj | Remove-TeamViewerDevice -APIToken $testAPIToken

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $APIToken -eq $testAPIToken -and $Uri -eq '//unit.test/devices/d1234' -and $Method -eq 'Delete' }
    }
}
