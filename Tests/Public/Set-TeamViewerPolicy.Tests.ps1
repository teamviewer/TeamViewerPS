BeforeAll {
    . "$PSScriptRoot/../../docs/Cmdlets/Public/Set-TeamViewerPolicy.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot/../../docs/Cmdlets/Private/*.ps1") | `
        ForEach-Object { . $_.FullName }

    $testApiToken = [securestring]@{}
    $null = $testApiToken
    $testPolicyId = '5fc4deaf-3789-4a83-a46a-a75864b71804'
    $null = $testPolicyId
    $mockArgs = @{}

    Mock Get-TeamViewerApiUri { '//unit.test' }
    Mock Invoke-TeamViewerRestMethod { $mockArgs.Body = $Body; @{ id = 'u1234' } }
}

Describe 'Set-TeamViewerPolicy' {
    It 'Should call the correct API endpoint' {
        Set-TeamViewerPolicy `
            -ApiToken $testApiToken `
            -PolicyId $testPolicyId `
            -Name 'Updated Policy Name'

        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And `
                $Uri -eq "//unit.test/teamviewerpolicies/$testPolicyId" -And `
                $Method -eq 'Put' }
    }

    It 'Should change policy properties' {
        Set-TeamViewerPolicy `
            -ApiToken $testApiToken `
            -PolicyId $testPolicyId `
            -Name 'Updated Policy Name'

        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $body.name | Should -Be 'Updated Policy Name'
    }

    It 'Should change policy settings' {
        $settings = @{
            Key     = "BlackWhitelist"
            Value   = @{
                UseWhiteList             = $true
                WhiteListBuddyAccountIds = @(123, 456, 789)
            }
            Enforce = $true
        }
        Set-TeamViewerPolicy `
            -ApiToken $testApiToken `
            -PolicyId $testPolicyId `
            -Settings $settings

        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $body.settings | Should -HaveCount 1
        $body.settings[0].Key | Should -Be 'BlackWhitelist'
        $body.settings[0].Value.UseWhiteList | Should -BeTrue
        $body.settings[0].Value.WhiteListBuddyAccountIds | Should -HaveCount 3
        $body.settings[0].Value.WhiteListBuddyAccountIds | Should -Be @(123,456,789)
    }

    It 'Should accept policy properties as hashtable' {
        Set-TeamViewerPolicy `
            -ApiToken $testApiToken `
            -PolicyId $testPolicyId `
            -Property @{
            name = 'Updated Policy Name'
        }

        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $body.name | Should -Be 'Updated Policy Name'
    }

    It 'Should throw if hashtable does not contain any valid change' {
        { Set-TeamViewerPolicy `
                -ApiToken $testApiToken `
                -PolicyId $testPolicyId `
                -Property @{
                foo = 'bar'
            } } | Should -Throw
    }
}
