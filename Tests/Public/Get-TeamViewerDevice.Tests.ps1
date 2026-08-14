BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Get-TeamViewerDevice.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }

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
    It 'Should reject a non-positive TeamViewer ID' {
        { Get-TeamViewerDevice -ApiToken $testApiToken -TeamViewerId 0 } | Should -Throw
    }

    It 'Should call the correct API endpoint to list devices' {
        Get-TeamViewerDevice -ApiToken $testApiToken

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -and `
                $Uri -eq '//unit.test/devices' -and `
                $Method -eq 'Get' }
    }

    It 'Should call the correct API endpoint for single device' {
        Get-TeamViewerDevice -ApiToken $testApiToken -Id 'd1234'

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -and `
                $Uri -eq '//unit.test/devices/d1234' -and `
                $Method -eq 'Get' }
    }

    It 'Should return Device objects' {
        $result = Get-TeamViewerDevice -ApiToken $testApiToken
        $result | Should -HaveCount 3
        $result[0].PSObject.TypeNames | Should -Contain 'TeamViewerPS.Device'
    }

    It 'Should allow to filter by TeamViewer ID' {
        Get-TeamViewerDevice -ApiToken $testApiToken -TeamViewerId 123456789

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $Body -and $Body['remotecontrol_id'] -eq 'r123456789' }
    }

    It 'Should allow to filter by online state' {
        Get-TeamViewerDevice -ApiToken $testApiToken -FilterOnlineState 'Busy'

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $Body -and $Body['online_state'] -eq 'busy' }
    }
}
