BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Move-TeamViewerManagedDevice.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | `
        ForEach-Object { . $_.FullName }

    $testApiToken = [securestring]@{}
    $null = $testApiToken
    $testDeviceId = '9e5617cb-2b20-4da2-bca4-c1bda85b29ab'
    $null = $testDeviceId
    $testSourceGroupId = 'c37e72b8-b78d-467f-923c-6083c13cf82f'
    $null = $testSourceGroupId
    $testTargetGroupId = '5aa6c65b-4a24-465b-90da-197e5e883ac6'
    $null = $testTargetGroupId

    Mock Get-TeamViewerApiUri { '//unit.test' }
    $mockArgs = @{}
    Mock Invoke-TeamViewerRestMethod { $mockArgs.Body = $Body }
}

Describe 'Move-TeamViewerManagedDevice' {
    It 'Should call the correct API endpoint to move a managed device from one group to another' {
        Move-TeamViewerManagedDevice `
            -ApiToken $testApiToken `
            -Device $testDeviceId `
            -SourceGroup $testSourceGroupId `
            -TargetGroup $testTargetGroupId
        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And `
                $Uri -eq "//unit.test/managed/devices/$testDeviceId/groups" -And `
                $Method -eq 'Put' }
    }

    It 'Should move the device from one group to another' {
        Move-TeamViewerManagedDevice `
            -ApiToken $testApiToken `
            -Device $testDeviceId `
            -SourceGroup $testSourceGroupId `
            -TargetGroup $testTargetGroupId
        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $body.AddedChainIds | Should -Be $testTargetGroupId
        $body.RemovedChainIds | Should -Be $testSourceGroupId
    }
}
