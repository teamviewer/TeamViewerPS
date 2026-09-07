BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Get-TeamViewerGroup.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }

    $testAPIToken = [securestring]@{}
    $null = $testAPIToken

    Mock Get-TeamViewerAPIUri { '//unit.test' }
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
        Get-TeamViewerGroup -APIToken $testAPIToken

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $APIToken -eq $testAPIToken -and $Uri -eq '//unit.test/groups' -and $Method -eq 'Get' }
    }

    It 'Should call the correct API endpoint for single group' {
        Get-TeamViewerGroup -APIToken $testAPIToken -Id 'g1234'

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $APIToken -eq $testAPIToken -and $Uri -eq '//unit.test/groups/g1234' -and $Method -eq 'Get' }
    }

    It 'Should return Group objects' {
        $Result = Get-TeamViewerGroup -APIToken $testAPIToken
        $Result | Should -HaveCount 3
        $Result[0].PSObject.TypeNames | Should -Contain 'TeamViewerPS.Group'
    }

    It 'Should allow to filter for shared-groups' {
        Get-TeamViewerGroup -APIToken $testAPIToken -FilterBy_Shared OnlyShared

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $Body -and $Body['shared'] -eq $true }

        Get-TeamViewerGroup -APIToken $testAPIToken -FilterBy_Shared OnlyNotShared

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $Body -and $Body['shared'] -eq $false }

        Get-TeamViewerGroup -APIToken $testAPIToken

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $Body -and $Body['shared'] -eq $null }
    }

    It 'Should allow to filter by partial name' {
        Get-TeamViewerGroup -APIToken $testAPIToken -Name 'TestName'

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $Body -and $Body['name'] -eq 'TestName' }
    }

    It 'Should include PolicyId when getting single group' {
        $Result = Get-TeamViewerGroup -APIToken $testAPIToken -Id 'g1234'
        $Result.Policy_Id | Should -Be 'p1234'
    }

    It 'Should include PolicyId when filtering groups' {
        $Result = Get-TeamViewerGroup -APIToken $testAPIToken
        $Result[0].Policy_Id | Should -Be 'p1234'
    }
}
