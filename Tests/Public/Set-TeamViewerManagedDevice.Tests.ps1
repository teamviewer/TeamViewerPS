BeforeAll {
    . "$PSScriptRoot/../../Docs/Cmdlets/Public/Set-TeamViewerManagedDevice.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot/../../Docs/Cmdlets/Private/*.ps1") | `
        ForEach-Object { . $_.FullName }

    $testApiToken = [securestring]@{}
    $null = $testApiToken
    $testDeviceId = '9e5617cb-2b20-4da2-bca4-c1bda85b29ab'
    $null = $testDeviceId

    Mock Get-TeamViewerApiUri { '//unit.test' }
    $mockArgs = @{}
    Mock Invoke-TeamViewerRestMethod { $mockArgs.Body = $Body }
}

Describe 'Set-TeamViewerManagedDevice' {

    It 'Should call the correct API endpoint to update a managed device' {
        Set-TeamViewerManagedDevice -ApiToken $testApiToken -Device $testDeviceId -Name 'Foo Bar'
        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And `
                $Uri -eq "//unit.test/managed/devices/$testDeviceId" -And `
                $Method -eq 'Put' }
    }

    It 'Should update the managed device alias' {
        Set-TeamViewerManagedDevice -ApiToken $testApiToken -Device $testDeviceId -Name 'Foo Bar'
        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $body.name | Should -Be 'Foo Bar'
    }

    It 'Should update the managed device policy' {
        Set-TeamViewerManagedDevice -ApiToken $testApiToken -Device $testDeviceId -Policy '2871c013-3040-4969-9ba4-ce970f4375e8'
        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $body.teamviewerPolicyId | Should -Be '2871c013-3040-4969-9ba4-ce970f4375e8'
    }

    It 'Should remove the managed device policy' {
        Set-TeamViewerManagedDevice -ApiToken $testApiToken -Device $testDeviceId -RemovePolicy
        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $body.teamviewerPolicyId | Should -Be ''
    }

    It 'Should not be possible to set and remove the policy at the same time' {
        { Set-TeamViewerManagedDevice `
                -ApiToken $testApiToken `
                -Device $testDeviceId `
                -Policy '2871c013-3040-4969-9ba4-ce970f4375e8' `
                -RemovePolicy } | Should -Throw
    }

    It 'Should not be possible to use "none" or "inherit" as values for policy' {
        { Set-TeamViewerManagedDevice `
                -ApiToken $testApiToken `
                -Device $testDeviceId `
                -Policy 'none' } | Should -Throw
        { Set-TeamViewerManagedDevice `
                -ApiToken $testApiToken `
                -Device $testDeviceId `
                -Policy 'inherit' } | Should -Throw
    }

    It 'Should accept a ManagedDevice object as input' {
        $testDevice = @{ id = $testDeviceId; name = 'test device' } | ConvertTo-TeamViewerManagedDevice
        Set-TeamViewerManagedDevice -ApiToken $testApiToken -Device $testDevice -Name 'Foo Bar'
        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And `
                $Uri -eq "//unit.test/managed/devices/$testDeviceId" -And `
                $Method -eq 'Put' }
    }

    It 'Should throw an error when called without changes' {
        { Set-TeamViewerManagedDevice `
                -ApiToken $testApiToken `
                -Device $testDeviceId } | Should -Throw
    }
}
