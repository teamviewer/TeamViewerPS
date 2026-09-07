BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Set-TeamViewerManagedGroup.ps1"
    . "$PSScriptRoot\..\..\Cmdlets\TeamViewerPS.Types.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }

    $testAPIToken = [securestring]@{}
    $null = $testAPIToken
    $testGroupId = '9e5617cb-2b20-4da2-bca4-c1bda85b29ab'
    $null = $testGroupId

    Mock Get-TeamViewerAPIUri { '//unit.test' }
    $mockArgs = @{}
    Mock Invoke-TeamViewerRestMethod { $mockArgs.Body = $Body }
}

Describe 'Set-TeamViewerManagedGroup' {
    Context 'Parameter aliases' {
        It 'Should expose <Alias> as an alias of the <Param> parameter' -ForEach @(
            @{ Param = 'Group'; Alias = 'Id' }
            @{ Param = 'Group'; Alias = 'GroupId' }
            @{ Param = 'Group'; Alias = 'ManagedGroupId' }
            @{ Param = 'Group'; Alias = 'ManagedGroup' }
        ) {
            (Get-Command -Name Set-TeamViewerManagedGroup).Parameters[$Param].Aliases | Should -Contain $Alias
        }
    }
    It 'Should call the correct API endpoint to update managed group' {
        Set-TeamViewerManagedGroup -APIToken $testAPIToken -GroupId $testGroupId -Name 'Foo Bar'

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $APIToken -eq $testAPIToken -and $Uri -eq "//unit.test/managed/groups/$testGroupId" -and $Method -eq 'Put' }
    }

    It 'Should update the TeamViewer policy ByParameters' {
        Set-TeamViewerManagedGroup -APIToken $testAPIToken -GroupId $testGroupId -PolicyId '9ff05c52-432c-4574-93ee-25e303fd7407' -PolicyType 'TeamViewer'

        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $Body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $Body.policy.policy_id | Should -Be '9ff05c52-432c-4574-93ee-25e303fd7407'
        $Body.policy.policy_type | Should -Be 1
    }

    It 'Should update the Monitoring policy ByParameters' {
        Set-TeamViewerManagedGroup -APIToken $testAPIToken -GroupId $testGroupId -PolicyId '9ff05c52-432c-4574-93ee-25e303fd7407' -PolicyType 'Monitoring'

        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $Body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $Body.policy.policy_id | Should -Be '9ff05c52-432c-4574-93ee-25e303fd7407'
        $Body.policy.policy_type | Should -Be 4
    }

    It 'Should update the Patch Management policy ByParameters' {
        Set-TeamViewerManagedGroup -APIToken $testAPIToken -GroupId $testGroupId -PolicyId '9ff05c52-432c-4574-93ee-25e303fd7407' -PolicyType 'PatchManagement'

        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $Body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $Body.policy.policy_id | Should -Be '9ff05c52-432c-4574-93ee-25e303fd7407'
        $Body.policy.policy_type | Should -Be 5
    }

    It 'Should update the TeamViewer policy ByProperties' {
        Set-TeamViewerManagedGroup -APIToken $testAPIToken -GroupId $testGroupId -Property @{
            name        = 'Foo Bar'
            policy_id   = '9ff05c52-432c-4574-93ee-25e303fd7407'
            policy_type = 'TeamViewer'
        }

        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $Body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $Body.policy.policy_id | Should -Be '9ff05c52-432c-4574-93ee-25e303fd7407'
        $Body.policy.policy_type | Should -Be 1
    }

    It 'Should update the Monitoring policy ByProperties' {
        Set-TeamViewerManagedGroup -APIToken $testAPIToken -GroupId $testGroupId -Property @{
            policy_id   = '9ff05c52-432c-4574-93ee-25e303fd7407'
            policy_type = 'Monitoring'
        }

        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $Body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $Body.policy.policy_id | Should -Be '9ff05c52-432c-4574-93ee-25e303fd7407'
        $Body.policy.policy_type | Should -Be 4
    }

    It 'Should update the Patch Management policy ByProperties' {
        Set-TeamViewerManagedGroup -APIToken $testAPIToken -GroupId $testGroupId -Property @{
            policy_id   = '9ff05c52-432c-4574-93ee-25e303fd7407'
            policy_type = 'PatchManagement'
        }

        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $Body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $Body.policy.policy_id | Should -Be '9ff05c52-432c-4574-93ee-25e303fd7407'
        $Body.policy.policy_type | Should -Be 5
    }

    It 'Should accept a properties hashtable as input' {
        Set-TeamViewerManagedGroup -APIToken $testAPIToken -GroupId $testGroupId -Property @{
            policy_id   = '9ff05c52-432c-4574-93ee-25e303fd7407'
            policy_type = 'TeamViewer'
        }

        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $Body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $Body.policy.policy_id | Should -Be '9ff05c52-432c-4574-93ee-25e303fd7407'
        $Body.policy.policy_type | Should -Be 1
    }

    It 'Should not be possible to set only policy_id or policy_type' {
        { Set-TeamViewerManagedGroup -APIToken $testAPIToken -GroupId $testGroupId -Property @{ policy_type = 'TeamViewer' }
        } | Should -Throw

        { Set-TeamViewerManagedGroup -APIToken $testAPIToken -GroupId $testGroupId -Property @{ policy_id = '9ff05c52-432c-4574-93ee-25e303fd7407' }
        } | Should -Throw

        { Set-TeamViewerManagedGroup -APIToken $testAPIToken -GroupId $testGroupId -PolicyType 'PatchManagement'
        } | Should -Throw

        { Set-TeamViewerManagedGroup -APIToken $testAPIToken -GroupId $testGroupId -PolicyId '9ff05c52-432c-4574-93ee-25e303fd7407' `
        } | Should -Throw
    }

    It 'Should accept a ManagedGroup object as input' {
        $testGroup = @{id = $testGroupId; name = 'test managed group' } | ConvertTo-TeamViewerManagedGroup

        Set-TeamViewerManagedGroup -APIToken $testAPIToken -Group $testGroup -Name 'Foo Bar'

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $APIToken -eq $testAPIToken -and $Uri -eq "//unit.test/managed/groups/$testGroupId" -and $Method -eq 'Put' }
    }

    It 'Should accept pipeline input' {
        $testGroup = @{id = $testGroupId; name = 'test managed group' } | ConvertTo-TeamViewerManagedGroup
        $testGroup | Set-TeamViewerManagedGroup -APIToken $testAPIToken -Name 'Foo Bar'

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $APIToken -eq $testAPIToken -and $Uri -eq "//unit.test/managed/groups/$testGroupId" -and $Method -eq 'Put' }
    }
}
