BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Set-TeamViewerManagedGroup.ps1"
    . "$PSScriptRoot\..\..\Cmdlets\TeamViewerPS.Types.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | `
        ForEach-Object { . $_.FullName }

    $testApiToken = [securestring]@{}
    $null = $testApiToken
    $testGroupId = '9e5617cb-2b20-4da2-bca4-c1bda85b29ab'
    $null = $testGroupId

    Mock Get-TeamViewerApiUri { '//unit.test' }
    $mockArgs = @{}
    Mock Invoke-TeamViewerRestMethod { $mockArgs.Body = $Body }
}

Describe 'Set-TeamViewerManagedGroup' {

    It 'Should call the correct API endpoint to update managed group' {
        Set-TeamViewerManagedGroup -ApiToken $testApiToken -GroupId $testGroupId -Name 'Foo Bar'
        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And `
                $Uri -eq "//unit.test/managed/groups/$testGroupId" -And `
                $Method -eq 'Put' }
    }

    It 'Should update the TeamViewer policy ByParameters' {
        Set-TeamViewerManagedGroup `
            -ApiToken $testApiToken `
            -GroupId $testGroupId `
            -PolicyId '9ff05c52-432c-4574-93ee-25e303fd7407' `
            -PolicyType 'TeamViewer'
        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $body.policy.policy_id | Should -Be '9ff05c52-432c-4574-93ee-25e303fd7407'
        $body.policy.policy_type | Should -Be 1
    }

    It 'Should update the Monitoring policy ByParameters' {
        Set-TeamViewerManagedGroup `
            -ApiToken $testApiToken `
            -GroupId $testGroupId `
            -PolicyId '9ff05c52-432c-4574-93ee-25e303fd7407' `
            -PolicyType 'Monitoring'
        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $body.policy.policy_id | Should -Be '9ff05c52-432c-4574-93ee-25e303fd7407'
        $body.policy.policy_type | Should -Be 4
    }

    It 'Should update the Patch Management policy ByParameters' {
        Set-TeamViewerManagedGroup `
            -ApiToken $testApiToken `
            -GroupId $testGroupId `
            -PolicyId '9ff05c52-432c-4574-93ee-25e303fd7407' `
            -PolicyType 'PatchManagement'
        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $body.policy.policy_id | Should -Be '9ff05c52-432c-4574-93ee-25e303fd7407'
        $body.policy.policy_type | Should -Be 5
    }

    It 'Should update the TeamViewer policy ByProperties' {
        Set-TeamViewerManagedGroup `
            -ApiToken $testApiToken `
            -GroupId $testGroupId `
            -Property @{
                name        = 'Foo Bar'
                policy_id   = '9ff05c52-432c-4574-93ee-25e303fd7407'
                policy_type = 'TeamViewer'
            }

        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $body.policy.policy_id | Should -Be '9ff05c52-432c-4574-93ee-25e303fd7407'
        $body.policy.policy_type | Should -Be 1
    }

    It 'Should update the Monitoring policy ByProperties' {
        Set-TeamViewerManagedGroup `
            -ApiToken $testApiToken `
            -GroupId $testGroupId `
            -Property @{
                policy_id   = '9ff05c52-432c-4574-93ee-25e303fd7407'
                policy_type = 'Monitoring'
            }

        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $body.policy.policy_id | Should -Be '9ff05c52-432c-4574-93ee-25e303fd7407'
        $body.policy.policy_type | Should -Be 4
    }

    It 'Should update the Patch Management policy ByProperties' {
        Set-TeamViewerManagedGroup `
            -ApiToken $testApiToken `
            -GroupId $testGroupId `
            -Property @{
                policy_id   = '9ff05c52-432c-4574-93ee-25e303fd7407'
                policy_type = 'PatchManagement'
            }

        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $body.policy.policy_id | Should -Be '9ff05c52-432c-4574-93ee-25e303fd7407'
        $body.policy.policy_type | Should -Be 5
    }

    It 'Should accept a properties hashtable as input' {
        Set-TeamViewerManagedGroup `
            -ApiToken $testApiToken `
            -GroupId $testGroupId `
            -Property  @{
                policy_id   = '9ff05c52-432c-4574-93ee-25e303fd7407'
                policy_type = 'TeamViewer'
            }

        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $body.policy.policy_id | Should -Be '9ff05c52-432c-4574-93ee-25e303fd7407'
        $body.policy.policy_type | Should -Be 1
    }

    It 'Should not be possible to set only policy_id or policy_type' {
        { Set-TeamViewerManagedGroup `
                -ApiToken $testApiToken `
                -GroupId $testGroupId `
                -Property @{ policy_type = 'TeamViewer' }
        } | Should -Throw

        { Set-TeamViewerManagedGroup `
                -ApiToken $testApiToken `
                -GroupId $testGroupId `
                -Property @{ policy_id = '9ff05c52-432c-4574-93ee-25e303fd7407' }
        } | Should -Throw

        { Set-TeamViewerManagedGroup `
                -ApiToken $testApiToken `
                -GroupId $testGroupId `
                -PolicyType 'PatchManagement'
        } | Should -Throw

        { Set-TeamViewerManagedGroup `
                -ApiToken $testApiToken `
                -GroupId $testGroupId `
                -PolicyId '9ff05c52-432c-4574-93ee-25e303fd7407' `
        } | Should -Throw
    }

    It 'Should accept a ManagedGroup object as input' {
        $testGroup = @{id = $testGroupId; name = 'test managed group' } | ConvertTo-TeamViewerManagedGroup
        Set-TeamViewerManagedGroup -ApiToken $testApiToken -Group $testGroup -Name 'Foo Bar'
        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And `
                $Uri -eq "//unit.test/managed/groups/$testGroupId" -And `
                $Method -eq 'Put' }
    }

    It 'Should accept pipeline input' {
        $testGroup = @{id = $testGroupId; name = 'test managed group' } | ConvertTo-TeamViewerManagedGroup
        $testGroup | Set-TeamViewerManagedGroup -ApiToken $testApiToken -Name 'Foo Bar'
        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And `
                $Uri -eq "//unit.test/managed/groups/$testGroupId" -And `
                $Method -eq 'Put' }
    }
}
