BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Get-TeamViewerOrganizationalUnit.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | `
        ForEach-Object { . $_.FullName }

    $testApiToken = [securestring]@{}
    $null = $testApiToken

    Mock Get-TeamViewerApiUri { '//unit.test' }
    Mock Invoke-TeamViewerRestMethod { @{
            organizationalunits = @(
                @{ id = '1cbae0b5-8a2f-487a-a8cf-5b884787b52c'; name = '1st organizational unit' },
                @{ id = '0272594a-41ba-4f45-8eeb-37296931b0a1'; name = '2nd organizational unit' },
                @{ id = 'ceb86e1a-61a8-4b76-a574-692f10c1a415'; name = '3rd organizational unit' }
            )
        } }
}

Describe 'Get-TeamViewerOrganizationalUnit' {

    It 'Should call the correct API endpoint to list organizational units' {
        Get-TeamViewerOrganizationalUnit -ApiToken $testApiToken

        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And $Uri -eq '//unit.test/organizationalunits' -And $Method -eq 'Get'
        }
    }

    It 'Should call the correct API endpoint for a single organizational unit' {
        Get-TeamViewerOrganizationalUnit -ApiToken $testApiToken -OrganizationalUnit '1cbae0b5-8a2f-487a-a8cf-5b884787b52c'

        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And $Uri -eq '//unit.test/organizationalunits/1cbae0b5-8a2f-487a-a8cf-5b884787b52c' -And $Method -eq 'Get'
        }
    }

    It 'Should return organizational unit objects' {
        $result = Get-TeamViewerOrganizationalUnit -ApiToken $testApiToken
        $result | Should -HaveCount 3
        $result[0].PSObject.TypeNames | Should -Contain 'TeamViewerPS.OrganizationalUnit'
    }

    It 'Should allow to filter organizational units by partial name' {
        Get-TeamViewerOrganizationalUnit -ApiToken $testApiToken -Name '2nd'
        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter { $Body -And $Body['name'] -eq '2nd' }
    }
}
