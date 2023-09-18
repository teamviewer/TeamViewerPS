BeforeAll {
    . "$PSScriptRoot/../../Docs/Cmdlets/Public/New-TeamViewerDevice.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot/../../Docs/Cmdlets/Private/*.ps1") | `
        ForEach-Object { . $_.FullName }

    $testApiToken = [securestring]@{}
    $null = $testApiToken
    $mockArgs = @{}

    Mock Get-TeamViewerApiUri { '//unit.test' }
    Mock Invoke-TeamViewerRestMethod {
        $mockArgs.Body = $Body
        @{
            id      = 'd1234'
            alias   = 'Test Device 1'
            groupid = 'g5678'
        }
    }

    function ConvertTo-TestPassword {
        # We do this only for testing
        [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingConvertToSecureStringWithPlainText', '')]
        param()
        Process { $_ | ConvertTo-SecureString -AsPlainText -Force }
    }
}

Describe 'New-TeamViewerDevice' {
    It 'Should call the correct API endpoint' {
        New-TeamViewerDevice -ApiToken $testApiToken -TeamViewerId 1234 -Group 'g5678'
        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And `
                $Uri -eq '//unit.test/devices' -And `
                $Method -eq 'Post' }
    }

    It 'Should include the given input parameters in the request' {
        $testPassword = 'Test1234' | ConvertTo-TestPassword
        New-TeamViewerDevice `
            -ApiToken $testApiToken `
            -TeamViewerId 1234 `
            -Group 'g5678' `
            -Name 'My Device' `
            -Description 'Some Device' `
            -Password $testPassword
        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $body.remotecontrol_id | Should -Be 'r1234'
        $body.groupid | Should -Be 'g5678'
        $body.alias | Should -Be 'My Device'
        $body.description | Should -Be 'Some Device'
        $body.password | Should -Be 'Test1234'
    }

    It 'Should accept Group objects' {
        $testGroupObj = @{ id = 'g5678' } | ConvertTo-TeamViewerGroup
        New-TeamViewerDevice -ApiToken $testApiToken -TeamViewerId 1234 -Group $testGroupObj
        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $body.remotecontrol_id | Should -Be 'r1234'
        $body.groupid | Should -Be 'g5678'
    }
}
