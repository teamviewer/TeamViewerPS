BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Add-TeamViewerManagedDevice.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | `
        ForEach-Object { . $_.FullName }

    $testApiToken = [securestring]@{}
    $null = $testApiToken
    $testGroupId = '9e5617cb-2b20-4da2-bca4-c1bda85b29ab'
    $null = $testGroupId
    $testDeviceId = 'c37e72b8-b78d-467f-923c-6083c13cf82f'
    $null = $testDeviceId

    Mock Get-TeamViewerApiUri { '//unit.test' }
    $mockArgs = @{}
    Mock Invoke-TeamViewerRestMethod { $mockArgs.Body = $Body }
}

Describe 'Add-TeamViewerManagedDevice' {
    It 'Should call the correct API endpoint to add managed group devices' {
        Add-TeamViewerManagedDevice `
            -ApiToken $testApiToken `
            -GroupId $testGroupId `
            -DeviceId $testDeviceId
        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And `
                $Uri -eq "//unit.test/managed/groups/$testGroupId/devices" -And `
                $Method -eq 'Post' }
    }

    It 'Should add the device to the group' {
        Add-TeamViewerManagedDevice `
            -ApiToken $testApiToken `
            -GroupId $testGroupId `
            -DeviceId $testDeviceId
        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $body.id | Should -Be $testDeviceId
    }

    It 'Should accept group objects as input' {
        $groupObj = @{id = $testGroupId } | ConvertTo-TeamViewerManagedGroup
        Add-TeamViewerManagedDevice `
            -ApiToken $testApiToken `
            -Group $groupObj `
            -DeviceId $testDeviceId
        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And `
                $Uri -eq "//unit.test/managed/groups/$testGroupId/devices" -And `
                $Method -eq 'Post' }
    }
}
