BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Get-TeamViewerDevice.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }

    $testAPIToken = [securestring]@{}
    $null = $testAPIToken

    Mock Get-TeamViewerAPIUri { '//unit.test' }
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
        { Get-TeamViewerDevice -APIToken $testAPIToken -TeamViewerId 0 } | Should -Throw
    }

    It 'Should call the correct API endpoint to list devices' {
        Get-TeamViewerDevice -APIToken $testAPIToken

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $APIToken -eq $testAPIToken -and `
                $Uri -eq '//unit.test/devices' -and `
                $Method -eq 'Get' }
    }

    It 'Should call the correct API endpoint for single device' {
        Get-TeamViewerDevice -APIToken $testAPIToken -Device 'd1234'

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $APIToken -eq $testAPIToken -and `
                $Uri -eq '//unit.test/devices/d1234' -and `
                $Method -eq 'Get' }
    }

    It 'Should return Device objects' {
        $Result = Get-TeamViewerDevice -APIToken $testAPIToken
        $Result | Should -HaveCount 3
        $Result[0].PSObject.TypeNames | Should -Contain 'TeamViewerPS.Device'
    }

    It 'Should allow to filter by TeamViewer ID' {
        Get-TeamViewerDevice -APIToken $testAPIToken -TeamViewerId 123456789

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $Body -and $Body['remotecontrol_id'] -eq 'r123456789' }
    }

    It 'Should allow to filter by online state' {
        Get-TeamViewerDevice -APIToken $testAPIToken -FilterBy_OnlineState 'Busy'

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $Body -and $Body['online_state'] -eq 'busy' }
    }
}
