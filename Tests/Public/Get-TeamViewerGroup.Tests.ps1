BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Get-TeamViewerGroup.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | `
        ForEach-Object { . $_.FullName }

    $testApiToken = [securestring]@{}
    $null = $testApiToken

    Mock Get-TeamViewerApiUri { '//unit.test' }
    Mock Invoke-TeamViewerRestMethod { @{
            groups = @(
                @{ id = 'g1234'; name = 'test group 1' },
                @{ id = 'g4567'; name = 'test group 2' },
                @{ id = 'g8901'; name = 'test group 3' }
            )
        } }
}

Describe 'Get-TeamViewerGroup' {

    It 'Should call the correct API endpoint to list groups' {
        Get-TeamViewerGroup -ApiToken $testApiToken

        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And `
                $Uri -eq '//unit.test/groups' -And `
                $Method -eq 'Get' }
    }

    It 'Should call the correct API endpoint for single group' {
        Get-TeamViewerGroup -ApiToken $testApiToken -Group 'g1234'

        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
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
        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $Body -And $Body['shared'] -eq $true }

        Get-TeamViewerGroup -ApiToken $testApiToken -FilterShared OnlyNotShared
        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $Body -And $Body['shared'] -eq $false }

        Get-TeamViewerGroup -ApiToken $testApiToken
        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $Body -And $Body['shared'] -eq $null }
    }

    It 'Should allow to filter by partial name' {
        Get-TeamViewerGroup -ApiToken $testApiToken -Name 'TestName'
        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $Body -And $Body['name'] -eq 'TestName' }
    }
}
