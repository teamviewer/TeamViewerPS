BeforeAll {
    . "$PSScriptRoot/../../TeamViewerPS/Public/Remove-TeamViewerPolicyFromManagedDevice.ps1"
    . "$PSScriptRoot/../../TeamViewerPS/TeamViewerPS.Types.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot/../../TeamViewerPS/Private/*.ps1") | `
        ForEach-Object { . $_.FullName }

    $testApiToken = [securestring]@{}
    $null = $testApiToken
    $testDeviceId = '9e5617cb-2b20-4da2-bca4-c1bda85b29ab'
    $null = $testDeviceId

    Mock Get-TeamViewerApiUri { '//unit.test' }
    $mockArgs = @{}
    Mock Invoke-TeamViewerRestMethod { $mockArgs.Body = $Body }
}

Describe 'Remove-TeamViewerPolicyFromManagedDevice' {

    It 'Should call the correct API endpoint to remove a policy from the managed device' {
        Remove-TeamViewerPolicyFromManagedDevice -ApiToken $testApiToken -Device $testDeviceId -PolicyType TeamViewer
        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And `
                $Uri -eq "//unit.test/managed/devices/$testDeviceId/policy/remove" -And `
                $Method -eq 'Put' }
    }

    It 'should remove teamviewer policy from managed device' {
        Remove-TeamViewerPolicyFromManagedDevice -apitoken $testapitoken -device $testdeviceid -Policytype TeamViewer
        $mockargs.body | Should -Not -BeNullOrEmpty
        $body = [system.text.encoding]::utf8.getstring($mockargs.body) | ConvertFrom-Json
        $body.policy_type | Should -Be 1
    }

    It 'should remove monitoring policy from managed device' {
        Remove-TeamViewerPolicyFromManagedDevice -apitoken $testapitoken -device $testdeviceid -PolicyType Monitoring
        $mockargs.body | Should -Not -BeNullOrEmpty
        $body = [system.text.encoding]::utf8.getstring($mockargs.body) | ConvertFrom-Json
        $body.policy_type | Should -Be 4
    }

    It 'should remove patch management policy from managed device' {
        Remove-TeamViewerPolicyFromManagedDevice -apitoken $testapitoken -device $testdeviceid -PolicyType PatchManagement
        $mockargs.body | Should -Not -BeNullOrEmpty
        $body = [system.text.encoding]::utf8.getstring($mockargs.body) | ConvertFrom-Json
        $body.policy_type | Should -Be 5
    }

    It 'Should throw an error when called with invalid policy type' {
        { Remove-TeamViewerPolicyFromManagedDevice `
                -ApiToken $testApiToken `
                -Device $testDeviceId -PolicyType 2 } | Should -Throw
    }
}

