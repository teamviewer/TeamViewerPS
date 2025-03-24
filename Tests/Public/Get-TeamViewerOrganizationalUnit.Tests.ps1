BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Get-TeamViewerOrganizationalUnit.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }

    $testApiToken = [securestring]@{}
    $null = $testApiToken
    $example_uuid = '7042bac2-7ce0-47c6-8c1a-fb00505bd6ed'
    $null = $example_uuid
    Mock Get-TeamViewerApiUri { '//unit.test' }
    Mock Invoke-TeamViewerRestMethod { @{
            data = @(
                @{
                    Name        = 'Root'
                    ParentId    = ''
                    Id          = 'd696ef85-d40a-479e-8331-4813f59e6481'
                    Description = ''
                    CreatedAt   = '24/03/2025 12:49:25'
                    UpdatedAt   = '24/03/2025 12:49:25'
                },
                @{
                    Name        = 'TestOU2'
                    ParentId    = 'd696ef85-d40a-479e-8331-4813f59e6481'
                    Id          = '7042bac2-7ce0-47c6-8c1a-fb00505bd6ed'
                    Description = ''
                    CreatedAt   = '24/03/2025 13:30:38'
                    UpdatedAt   = '24/03/2025 13:30:38'
                },
                @{
                    Name        = 'TestOUCMD'
                    ParentId    = 'd696ef85-d40a-479e-8331-4813f59e6481'
                    Id          = 'a400ad06-9c59-4a33-b110-4649fcce6f45'
                    Description = ''
                    CreatedAt   = '24/03/2025 13:43:02'
                    UpdatedAt   = '24/03/2025 13:43:02'
                }
            )
        } }




}

Describe 'Get-TeamViewerOrganizationalUnit' {

    It 'Should call the correct API endpoint to list users' {
        Get-TeamViewerOrganizationalUnit -ApiToken $testApiToken

        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And $Uri -eq '//unit.test/organizationalunits' -And $Method -eq 'Get' }
    }

    It 'Should call the correct API endpoint for single ID' {
        Get-TeamViewerOrganizationalUnit -ApiToken $testApiToken -Id $example_uuid

        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And $Uri -eq '//unit.test/organizationalunits/' + $example_uuid -And $Method -eq 'Get' }
    }

    It 'Should return Org unit objects' {
        $result = Get-TeamViewerOrganizationalUnit -ApiToken $testApiToken
        $result | Should -HaveCount 3
        $result[0].PSObject.TypeNames | Should -Contain 'TeamViewerPS.OrganizationalUnit'
    }

    It 'Should allow to filter by name' {
        Get-TeamViewerOrganizationalUnit -ApiToken $testApiToken -Filter 'Test'

        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $Body -And $Body['filter'] -eq 'Test' }
    }

    It 'Should allow to specification of IncludeChildren, StartOrganizationalUnitId, SortBy and Sort Order, Page Size and Page Number' {
        Get-TeamViewerOrganizationalUnit -ApiToken $testApiToken -IncludeChildren -StartOrganizationalUnitId $example_uuid -SortBy 'Name' -SortOrder 'Asc' -PageSize 200 -PageNumber 2

        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $Body -And $Body['IncludeChildren'] -eq $true -And $Body['StartOrganizationalUnitId'] -eq $example_uuid -And $Body['SortBy'] -eq 'Name' -And $Body['PageNumber'] -eq '2' -And $Body['SortOrder'] -eq 'Asc' -And $Body['PageSize'] -eq '200' }
    }

    It 'Should fail with empty filter' {
        { Get-TeamViewerOrganizationalUnit -ApiToken $testApiToken -Filter '' } | Should -Throw

    }
    It 'Should accept OrgUnit object as input' {
        $testGroupObj = @{ id = $example_uuid } | ConvertTo-TeamViewerOrganizationalUnit
        Get-TeamViewerOrganizationalUnit -ApiToken $testApiToken -Id $testGroupObj

        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And `
                $Uri -eq '//unit.test/organizationalunits/' + $example_uuid -And `
                $Method -eq 'Get' }
    }

    It 'Should accept pipeline objects' {
        $testGroupObj = @{ id = $example_uuid } | ConvertTo-TeamViewerOrganizationalUnit
        $testGroupObj | Get-TeamViewerOrganizationalUnit -ApiToken $testApiToken

        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And `
                $Uri -eq '//unit.test/organizationalunits/' + $example_uuid -And `
                $Method -eq 'Get' }
    }
}
