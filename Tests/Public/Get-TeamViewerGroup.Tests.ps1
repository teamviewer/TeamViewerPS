BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Get-TeamViewerGroup.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | `
        ForEach-Object { . $_.FullName }

    $testApiToken = [securestring]@{}
    $null = $testApiToken

    Mock Get-TeamViewerApiUri { '//unit.test' }
    Mock Invoke-TeamViewerRestMethod { @{
            groups = @(
                @{ id = 'g1234'; name = 'test group 1'; policy_id = 'p1234' },
                @{ id = 'g4567'; name = 'test group 2'; policy_id = 'p4567' },
                @{ id = 'g8901'; name = 'test group 3'; policy_id = 'p8901' }
            )
        } }
    Mock Invoke-TeamViewerRestMethod { @{ id = 'g1234'; name = 'test group 1'; policy_id = 'p1234' } } -ParameterFilter {
        $Uri -eq '//unit.test/groups/g1234'
    }
}

Describe 'Get-TeamViewerGroup' {

    It 'Should call the correct API endpoint to list groups' {
        Get-TeamViewerGroup -ApiToken $testApiToken

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And `
                $Uri -eq '//unit.test/groups' -And `
                $Method -eq 'Get' }
    }

    It 'Should call the correct API endpoint for single group' {
        Get-TeamViewerGroup -ApiToken $testApiToken -Id 'g1234'

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And `
                $Uri -eq '//unit.test/groups/g1234' -And `
                $Method -eq 'Get' }
    }

    It 'Should return Group objects' {
        $result = Get-TeamViewerGroup -ApiToken $testApiToken
        $result | Should -HaveCount 3
        $result[0].PSObject.TypeNames | Should -Contain 'TeamViewerPS.Group'
    }

    It 'Should allow to filter for shared-groups' {
        Get-TeamViewerGroup -ApiToken $testApiToken -FilterShared OnlyShared
        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $Body -And $Body['shared'] -eq $true }

        Get-TeamViewerGroup -ApiToken $testApiToken -FilterShared OnlyNotShared
        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $Body -And $Body['shared'] -eq $false }

        Get-TeamViewerGroup -ApiToken $testApiToken
        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $Body -And $Body['shared'] -eq $null }
    }

    It 'Should allow to filter by partial name' {
        Get-TeamViewerGroup -ApiToken $testApiToken -Name 'TestName'
        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $Body -And $Body['name'] -eq 'TestName' }
    }

    It 'Should include PolicyId when getting single group' {
        $result = Get-TeamViewerGroup -ApiToken $testApiToken -Id 'g1234'
        $result.PolicyId | Should -Be 'p1234'
    }

    It 'Should include PolicyId when filtering groups' {
        $result = Get-TeamViewerGroup -ApiToken $testApiToken
        $result[0].PolicyId | Should -Be 'p1234'
    }
}
