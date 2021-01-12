BeforeAll {
    . "$PSScriptRoot/../../TeamViewerPS/Public/Set-TeamViewerGroup.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot/../../TeamViewerPS/Private/*.ps1") | `
        ForEach-Object { . $_.FullName }

    $testApiToken = [securestring]@{}
    $null = $testApiToken
    $testPolicyId = 'f6bdc642-374e-4923-aac9-6845c73e322f'
    $null = $testPolicyId
    $mockArgs = @{}

    Mock Get-TeamViewerApiUri { '//unit.test' }
    Mock Invoke-TeamViewerRestMethod { $mockArgs.Body = $Body }
}

Describe 'Set-TeamViewerGroup' {
    It 'Should call the correct API endpoint' {
        Set-TeamViewerGroup -ApiToken $testApiToken -GroupId 'g1234' -Name 'Unit Test Group'

        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And `
                $Uri -eq '//unit.test/groups/g1234' -And `
                $Method -eq 'Put' }
    }

    It 'Should include the given name in the request' {
        Set-TeamViewerGroup -ApiToken $testApiToken -GroupId 'g1234' -Name 'Unit Test Group'

        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $body.name | Should -Be 'Unit Test Group'
    }

    It 'Should include the optional policy ID in the request' {
        Set-TeamViewerGroup -ApiToken $testApiToken -GroupId 'g1234' -Policy $testPolicyId

        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $body.policy_id | Should -Be $testPolicyId
    }

    It 'Should accept Group objects as input' {
        $testGroupObj = @{ id = 'g1234' } | ConvertTo-TeamViewerGroup
        Set-TeamViewerGroup -ApiToken $testApiToken -Group $testGroupObj -Name 'Unit Test Group'

        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And `
                $Uri -eq '//unit.test/groups/g1234' -And `
                $Method -eq 'Put' }
    }

    It 'Should accept pipeline objects' {
        $testGroupObj = @{ id = 'g1234' } | ConvertTo-TeamViewerGroup
        $testGroupObj | Set-TeamViewerGroup -ApiToken $testApiToken -Name 'Unit Test Group'

        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And `
                $Uri -eq '//unit.test/groups/g1234' -And `
                $Method -eq 'Put' }
    }

    It 'Should accept changes given as hashtable' {
        Set-TeamViewerGroup `
            -ApiToken $testApiToken `
            -GroupId 'g1234' `
            -Property @{
            name = 'Unit Test Group'
        }

        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $body.name | Should -Be 'Unit Test Group'
    }

    It 'Should throw if hashtable does not contain any valid change' {
        { Set-TeamViewerGroup `
                -ApiToken $testApiToken `
                -GroupId 'g1234' `
                -Property @{
                foo = 'bar'
            } } | Should -Throw
    }
}
