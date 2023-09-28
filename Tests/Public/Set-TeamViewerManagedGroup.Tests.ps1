BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Set-TeamViewerManagedGroup.ps1"

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

    It 'Should update the group name' {
        Set-TeamViewerManagedGroup -ApiToken $testApiToken -GroupId $testGroupId -Name 'Foo Bar'
        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $body.name | Should -Be 'Foo Bar'
    }

    It 'Should accept a properties hashtable as input' {
        Set-TeamViewerManagedGroup -ApiToken $testApiToken -GroupId $testGroupId -Property @{name = 'Foo Bar' }
        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $body.name | Should -Be 'Foo Bar'
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
