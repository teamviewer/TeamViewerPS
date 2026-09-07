BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Set-TeamViewerPolicy.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }

    $testAPIToken = [securestring]@{}
    $null = $testAPIToken
    $testPolicyId = '5fc4deaf-3789-4a83-a46a-a75864b71804'
    $null = $testPolicyId
    $mockArgs = @{}

    Mock Get-TeamViewerAPIUri { '//unit.test' }
    Mock Invoke-TeamViewerRestMethod { $mockArgs.Body = $Body; @{ id = 'u1234' } }
}

Describe 'Set-TeamViewerPolicy' {
    It 'Should call the correct API endpoint' {
        Set-TeamViewerPolicy -APIToken $testAPIToken -PolicyId $testPolicyId -Name 'Updated Policy Name'

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $APIToken -eq $testAPIToken -and $Uri -eq "//unit.test/teamviewerpolicies/$testPolicyId" -and $Method -eq 'Put' }
    }

    It 'Should change policy properties' {
        Set-TeamViewerPolicy -APIToken $testAPIToken -PolicyId $testPolicyId -Name 'Updated Policy Name'

        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $Body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $Body.name | Should -Be 'Updated Policy Name'
    }

    It 'Should change policy settings' {
        $settings = @{
            Key     = 'BlackWhitelist'
            Value   = @{
                UseWhiteList             = $true
                WhiteListBuddyAccountIds = @(123, 456, 789)
            }
            Enforce = $true
        }

        Set-TeamViewerPolicy -APIToken $testAPIToken -PolicyId $testPolicyId -Settings $settings

        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $Body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $Body.settings | Should -HaveCount 1
        $Body.settings[0].Key | Should -Be 'BlackWhitelist'
        $Body.settings[0].Value.UseWhiteList | Should -BeTrue
        $Body.settings[0].Value.WhiteListBuddyAccountIds | Should -HaveCount 3
        $Body.settings[0].Value.WhiteListBuddyAccountIds | Should -Be @(123, 456, 789)
    }

    It 'Should accept policy properties as hashtable' {
        Set-TeamViewerPolicy -APIToken $testAPIToken -PolicyId $testPolicyId -Property @{
            name = 'Updated Policy Name'
        }

        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $Body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $Body.name | Should -Be 'Updated Policy Name'
    }

    It 'Should throw if hashtable does not contain any valid change' {
        { Set-TeamViewerPolicy -APIToken $testAPIToken -PolicyId $testPolicyId -Property @{
                foo = 'bar'
            } } | Should -Throw
    }
}
