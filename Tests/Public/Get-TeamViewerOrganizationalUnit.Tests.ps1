BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Get-TeamViewerOrganizationalUnit.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }

    $testApiToken = [securestring]@{}
    $null = $testApiToken
    $null = $example_uuid
    $example_uuid = '7042bac2-7ce0-47c6-8c1a-fb00505bd6ed'

    Mock Get-TeamViewerApiUri { '//unit.test' }
    Mock Invoke-TeamViewerRestMethod { @{
            data = @(
                @{
                    name        = 'Root'
                    parentId    = ''
                    id          = 'd696ef85-d40a-479e-8331-4813f59e6481'
                    description = ''
                    createdAt   = '24/03/2025 12:49:25'
                    updatedAt   = '24/03/2025 12:49:25'
                },
                @{
                    name        = 'TestOU2'
                    parentId    = 'd696ef85-d40a-479e-8331-4813f59e6481'
                    id          = '7042bac2-7ce0-47c6-8c1a-fb00505bd6ed'
                    description = ''
                    createdAt   = '24/03/2025 13:30:38'
                    updatedAt   = '24/03/2025 13:30:38'
                },
                @{
                    name        = 'TestOUCMD'
                    parentId    = 'd696ef85-d40a-479e-8331-4813f59e6481'
                    id          = 'a400ad06-9c59-4a33-b110-4649fcce6f45'
                    description = ''
                    createdAt   = '24/03/2025 13:43:02'
                    updatedAt   = '24/03/2025 13:43:02'
                }
            )
        } }
}

Describe 'Get-TeamViewerOrganizationalUnit' {

    It 'Should call the correct API endpoint to list users' {
        Get-TeamViewerOrganizationalUnit -ApiToken $testApiToken

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -and $Uri -eq '//unit.test/organizationalunits' -and $Method -eq 'Get' }
    }

    It 'Should call the correct API endpoint for single ID' {
        Get-TeamViewerOrganizationalUnit -ApiToken $testApiToken -Id $example_uuid

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -and $Uri -eq '//unit.test/organizationalunits/' + $example_uuid -and $Method -eq 'Get' }
    }

    It 'Should return Org unit objects' {
        $result = Get-TeamViewerOrganizationalUnit -ApiToken $testApiToken
        $result | Should -HaveCount 3
        $result[0].PSObject.TypeNames | Should -Contain 'TeamViewerPS.OrganizationalUnit'
    }

    It 'Should allow to filter by name' {
        Get-TeamViewerOrganizationalUnit -ApiToken $testApiToken -Filter 'Test'

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $Body -and $Body['filter'] -eq 'Test' }
    }

    It 'Should allow to specification of IncludeChildren, StartOrganizationalUnitId, SortBy and Sort Order, Page Size and Page Number' {
        Get-TeamViewerOrganizationalUnit -ApiToken $testApiToken -IncludeChildren -Parent $example_uuid -SortBy 'Name' -SortOrder 'Asc' -PageSize 200 -PageNumber 2

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $Body -and $Body['includeChildren'] -eq $true -and $Body['startOrganizationalUnitId'] -eq $example_uuid -and $Body['sortBy'] -eq 'Name' -and $Body['pageNumber'] -eq 2 -and $Body['sortOrder'] -eq 'Asc' -and $Body['pageSize'] -eq 200 }
    }

    It 'Should fail with empty filter' {
        { Get-TeamViewerOrganizationalUnit -ApiToken $testApiToken -Filter '' } | Should -Throw

    }
    It 'Should accept OrgUnit object as input' {
        $testGroupObj = @{ id = $example_uuid } | ConvertTo-TeamViewerOrganizationalUnit

        Get-TeamViewerOrganizationalUnit -ApiToken $testApiToken -Id $testGroupObj

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -and `
                $Uri -eq '//unit.test/organizationalunits/' + $example_uuid -and `
                $Method -eq 'Get' }
    }

    It 'Should accept pipeline objects' {
        $testGroupObj = @{ id = $example_uuid } | ConvertTo-TeamViewerOrganizationalUnit
        $testGroupObj | Get-TeamViewerOrganizationalUnit -ApiToken $testApiToken

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -and `
                $Uri -eq '//unit.test/organizationalunits/' + $example_uuid -and `
                $Method -eq 'Get' }
    }
}
