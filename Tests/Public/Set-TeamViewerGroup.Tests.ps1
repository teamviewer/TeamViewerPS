BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Set-TeamViewerGroup.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }

    $testAPIToken = [securestring]@{}
    $null = $testAPIToken
    $testPolicyId = 'f6bdc642-374e-4923-aac9-6845c73e322f'
    $null = $testPolicyId
    $mockArgs = @{}

    Mock Get-TeamViewerAPIUri { '//unit.test' }
    Mock Invoke-TeamViewerRestMethod { $mockArgs.Body = $Body }
}

Describe 'Set-TeamViewerGroup' {
    It 'Should call the correct API endpoint' {
        Set-TeamViewerGroup -APIToken $testAPIToken -GroupId 'g1234' -Name 'Unit Test Group'

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $APIToken -eq $testAPIToken -and $Uri -eq '//unit.test/groups/g1234' -and $Method -eq 'Put' }
    }

    It 'Should include the given name in the request' {
        Set-TeamViewerGroup -APIToken $testAPIToken -GroupId 'g1234' -Name 'Unit Test Group'

        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $Body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $Body.name | Should -Be 'Unit Test Group'
    }

    It 'Should include the optional policy Id in the request' {
        Set-TeamViewerGroup -APIToken $testAPIToken -GroupId 'g1234' -Policy $testPolicyId

        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $Body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $Body.policy_id | Should -Be $testPolicyId
    }

    It 'Should accept Group objects as input' {
        $testGroupObj = @{ id = 'g1234' } | ConvertTo-TeamViewerGroup

        Set-TeamViewerGroup -APIToken $testAPIToken -Group $testGroupObj -Name 'Unit Test Group'

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $APIToken -eq $testAPIToken -and $Uri -eq '//unit.test/groups/g1234' -and $Method -eq 'Put' }
    }

    It 'Should accept pipeline objects' {
        $testGroupObj = @{ id = 'g1234' } | ConvertTo-TeamViewerGroup
        $testGroupObj | Set-TeamViewerGroup -APIToken $testAPIToken -Name 'Unit Test Group'

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $APIToken -eq $testAPIToken -and $Uri -eq '//unit.test/groups/g1234' -and $Method -eq 'Put' }
    }

    It 'Should accept changes given as hashtable' {
        Set-TeamViewerGroup -APIToken $testAPIToken -GroupId 'g1234' -Property @{
            name = 'Unit Test Group'
        }

        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $Body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $Body.name | Should -Be 'Unit Test Group'
    }

    It 'Should throw if hashtable does not contain any valid change' {
        { Set-TeamViewerGroup -APIToken $testAPIToken -GroupId 'g1234' -Property @{
                foo = 'bar'
            } } | Should -Throw
    }
}
