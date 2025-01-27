BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Remove-TeamViewerOrganizationalUnit.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | `
        ForEach-Object { . $_.FullName }

    $testApiToken = [securestring]@{}
    $null = $testApiToken

    Mock Get-TeamViewerApiUri { '//unit.test' }
    Mock Invoke-TeamViewerRestMethod { }
}

Describe 'Remove-TeamViewerOrganizationalUnit' {
    It 'Should call the correct API endpoint' {
        Remove-TeamViewerOrganizationalUnit -ApiToken $testApiToken -OrganizationalUnit '1cbae0b5-8a2f-487a-a8cf-5b884787b52c'

        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And $Uri -eq '//unit.test/organizationalunits/1cbae0b5-8a2f-487a-a8cf-5b884787b52c' -And $Method -eq 'Delete'
        }
    }

    It 'Should accept organizational unit objects' {
        $TestOrgUnit = @{ id = '1cbae0b5-8a2f-487a-a8cf-5b884787b52c' } | ConvertTo-TeamViewerOrganizationalUnit
        Remove-TeamViewerOrganizationalUnit -ApiToken $testApiToken -OrganizationalUnit $TestOrgUnit

        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And $Uri -eq '//unit.test/organizationalunits/1cbae0b5-8a2f-487a-a8cf-5b884787b52c' -And $Method -eq 'Delete'
        }
    }

    It 'Should fail for invalid organizational unit identifiers' {
        { Remove-TeamViewerOrganizationalUnit -ApiToken $testApiToken -OrganizationalUnit 'invalid1234' } | Should -Throw
    }

    It 'Should accept pipeline input' {
        $TestOrgUnit = @{ Id = '1cbae0b5-8a2f-487a-a8cf-5b884787b52c' } | ConvertTo-TeamViewerOrganizationalUnit
        $TestOrgUnit | Remove-TeamViewerOrganizationalUnit -ApiToken $testApiToken

        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And $Uri -eq '//unit.test/organizationalunits/1cbae0b5-8a2f-487a-a8cf-5b884787b52c' -And $Method -eq 'Delete'
        }
    }
}
