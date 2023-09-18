BeforeAll {
    . "$PSScriptRoot/../../Docs/Cmdlets/Public/Set-TeamViewerDevice.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot/../../Docs/Cmdlets/Private/*.ps1") | `
        ForEach-Object { . $_.FullName }

    $testApiToken = [securestring]@{}
    $null = $testApiToken
    $mockArgs = @{}
    $testPolicyId = '2619781a-b1d6-481c-b933-7ce9756806d9'
    $null = $testPolicyId

    Mock Get-TeamViewerApiUri { '//unit.test' }
    Mock Invoke-TeamViewerRestMethod { $mockArgs.Body = $Body }

    function ConvertTo-TestPassword {
        # We do this only for testing
        [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingConvertToSecureStringWithPlainText', '')]
        param()
        Process { $_ | ConvertTo-SecureString -AsPlainText -Force }
    }
}

Describe 'Set-TeamViewerDevice' {
    It 'Should call the correct API endpoint' {
        Set-TeamViewerDevice -ApiToken $testApiToken -Id 'd1234' -Name 'My Updated Name'
        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And `
                $Uri -eq '//unit.test/devices/d1234' -And `
                $Method -eq 'Put' }
    }

    It 'Should include the given input parameters in the request' {
        $testPassword = 'Test1234' | ConvertTo-TestPassword
        Set-TeamViewerDevice `
            -ApiToken $testApiToken `
            -Id 'd1234' `
            -Name 'My Updated Name' `
            -Description 'My Updated Description' `
            -Password $testPassword
        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $body.alias | Should -Be 'My Updated Name'
        $body.description | Should -Be 'My Updated Description'
        $body.password | Should -Be 'Test1234'
    }

    It 'Should accept Device objects' {
        $testDeviceObj = @{ device_id = 'd1234' } | ConvertTo-TeamViewerDevice
        Set-TeamViewerDevice -ApiToken $testApiToken -Device $testDeviceObj -Name 'My Updated Name'
        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And `
                $Uri -eq '//unit.test/devices/d1234' -And `
                $Method -eq 'Put' }
    }

    It 'Should accept pipeline input' {
        $testDeviceObj = @{ device_id = 'd1234' } | ConvertTo-TeamViewerDevice
        $testDeviceObj | Set-TeamViewerDevice -ApiToken $testApiToken -Name 'My Updated Name'
        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And `
                $Uri -eq '//unit.test/devices/d1234' -And `
                $Method -eq 'Put' }
    }

    It 'Should accept Policy objects' {
        $testPolicyObj = @{policy_id = $testPolicyId } | ConvertTo-TeamViewerPolicy
        Set-TeamViewerDevice `
            -ApiToken $testApiToken `
            -Id 'd1234' `
            -Policy $testPolicyObj
        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $body.policy_id | Should -Be $testPolicyId
    }

    It 'Should set the policy to "<inputPolicy>"' -TestCases @(
        @{ inputPolicy = 'inherit' },
        @{ inputPolicy = 'none' },
        @{ inputPolicy = '2619781a-b1d6-481c-b933-7ce9756806d9' }
    ) {
        param($inputPolicy)
        Set-TeamViewerDevice -ApiToken $testApiToken -Id 'd1234' -Policy $inputPolicy
        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $body.policy_id | Should -Be $inputPolicy
    }

    It 'Should accept Group objects' {
        $testGroupObj = @{ id = 'g1234' } | ConvertTo-TeamViewerGroup
        Set-TeamViewerDevice -ApiToken $testApiToken -Id 'd1234' -Group $testGroupObj
        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $body.groupid | Should -Be 'g1234'
    }

    It 'Should not be possible to change the group and policy at the same time' {
        { Set-TeamViewerDevice `
                -ApiToken $testApiToken `
                -Id 'd1234' `
                -Group 'g1234' `
                -Policy 'inherit' } | Should -Throw
    }
}
