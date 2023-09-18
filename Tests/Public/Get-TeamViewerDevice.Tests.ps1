BeforeAll {
    . "$PSScriptRoot/../../Docs/Cmdlets/Public/Get-TeamViewerDevice.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot/../../Docs/Cmdlets/Private/*.ps1") | `
        ForEach-Object { . $_.FullName }

    $testApiToken = [securestring]@{}
    $null = $testApiToken

    Mock Get-TeamViewerApiUri { '//unit.test' }
    Mock Invoke-TeamViewerRestMethod { @{
            devices = @(
                @{ device_id = 'd1234'; alias = 'test device 1' },
                @{ device_id = 'd4567'; alias = 'test device 2' },
                @{ device_id = 'd8901'; alias = 'test device 3' }
            )
        } }
}

Describe 'Get-TeamViewerDevice' {
    It 'Should call the correct API endpoint to list devices' {
        Get-TeamViewerDevice -ApiToken $testApiToken
        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And `
                $Uri -eq '//unit.test/devices' -And `
                $Method -eq 'Get' }
    }

    It 'Should call the correct API endpoint for single device' {
        Get-TeamViewerDevice -ApiToken $testApiToken -Id 'd1234'
        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And `
                $Uri -eq '//unit.test/devices/d1234' -And `
                $Method -eq 'Get' }
    }

    It 'Should return Device objects' {
        $result = Get-TeamViewerDevice -ApiToken $testApiToken
        $result | Should -HaveCount 3
        $result[0].PSObject.TypeNames | Should -Contain 'TeamViewerPS.Device'
    }

    It 'Should allow to filter by TeamViewer ID' {
        Get-TeamViewerDevice -ApiToken $testApiToken -TeamViewerId 123456789
        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $Body -And $Body['remotecontrol_id'] -eq 'r123456789' }
    }

    It 'Should allow to filter by online state' {
        Get-TeamViewerDevice -ApiToken $testApiToken -FilterOnlineState 'Busy'
        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $Body -And $Body['online_state'] -eq 'busy' }
    }
}
