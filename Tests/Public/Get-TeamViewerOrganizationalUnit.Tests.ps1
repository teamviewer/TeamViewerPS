BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Get-TeamViewerOrganizationalUnit.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | `
        ForEach-Object { . $_.FullName }

    $testApiToken = [securestring]@{}
    $null = $testApiToken
    $testOrganizationalUnits = @(
        @{ id = '1cbae0b5-8a2f-487a-a8cf-5b884787b52c'; name = '1st organizational unit' },
        @{ id = '0272594a-41ba-4f45-8eeb-37296931b0a1'; name = '2nd organizational unit' },
        @{ id = 'ceb86e1a-61a8-4b76-a574-692f10c1a415'; name = '3rd organizational unit' }
    )
    $testOrganizationalUnitId = $testOrganizationalUnits[0].id
    $null = $testOrganizationalUnitId

    Mock Get-TeamViewerApiUri { '//unit.test' }
}

Describe 'Get-TeamViewerOrganizationalUnit' {

    Context 'Should return all organizational units' {
        BeforeAll {
            Mock Invoke-TeamViewerRestMethod { @{
                    resources = $testOrganizationalUnits
                } }
        }

        It 'Should call the correct API endpoint to list organizational units' {
            Get-TeamViewerOrganizationalUnit -ApiToken $testApiToken

            Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
                $ApiToken -eq $testApiToken -And `
                    $Uri -eq '//unit.test/organizationalunits' -And `
                    $Method -eq 'Get' }
        }

        It 'Should return OrganizationalUnit objects' {
            $result = Get-TeamViewerOrganizationalUnit -ApiToken $testApiToken
            $result | Should -HaveCount 3
            $result[0].PSObject.TypeNames | Should -Contain 'TeamViewerPS.OrganizationalUnit'
        }
    }

    Context 'Should retrieve a single group' {
        BeforeAll {
            Mock Invoke-TeamViewerRestMethod { $testOrganizationalUnits[0] }
        }

        It 'Should call the correct API endpoint for single organizational unit' {
            Get-TeamViewerOrganizationalUnit -ApiToken $testApiToken -OrganizationalUnit $testOrganizationalUnitId

            Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
                $ApiToken -eq $testApiToken -And `
                    $Uri -eq "//unit.test/organizationalunits/$testOrganizationalUnitId" -And `
                    $Method -eq 'Get' }
        }

        It 'Should handle domain object as input' {
            $testOrganizationalUnit = @{Id = $testOrganizationalUnitId; Name = 'test organizational unit' } | ConvertTo-TeamViewerOrganizationalUnit
            Get-TeamViewerOrganizationalUnit -ApiToken $testApiToken -OrganizationalUnit $testOrganizationalUnit

            Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
                $ApiToken -eq $testApiToken -And `
                    $Uri -eq "//unit.test/organizationalunits/$testOrganizationalUnitId" -And `
                    $Method -eq 'Get' }
        }

        It 'Should return a OrganizationalUnit object' {
            $result = Get-TeamViewerOrganizationalUnit -ApiToken $testApiToken -OrganizationalUnit $testOrganizationalUnitId
            $result | Should -BeOfType PSObject
            $result.PSObject.TypeNames | Should -Contain 'TeamViewerPS.OrganizationalUnit'
            $result.id | Should -Be $testOrganizationalUnits[0].id
            $result.name | Should -Be $testOrganizationalUnits[0].name
        }
    }
}
