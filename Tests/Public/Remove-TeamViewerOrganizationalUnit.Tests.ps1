BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Remove-TeamViewerOrganizationalUnit.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | `
        ForEach-Object { . $_.FullName }

    $testApiToken = [securestring]@{}
    $null = $testApiToken
    $testOrganizationalUnitId = '1cbae0b5-8a2f-487a-a8cf-5b884787b52c'
    $null = $testOrganizationalUnitId

    Mock Get-TeamViewerApiUri { '//unit.test' }
    Mock Invoke-TeamViewerRestMethod {}
}

Describe 'Remove-TeamViewerOrganizationalUnit' {

    It 'Should call the correct API endpoint' {
        Remove-TeamViewerOrganizationalUnit -ApiToken $testApiToken -OrganizationalUnit $testOrganizationalUnitId

        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And `
                $Uri -eq "//unit.test/organizationalunits/$testOrganizationalUnitId" -And `
                $Method -eq 'Delete'
        }
    }

    It 'Should handle domain object as input' {
        $testOrganizationalUnit = @{Id = $testOrganizationalUnitId } | ConvertTo-TeamViewerOrganizationalUnit
        Remove-TeamViewerOrganizationalUnit -ApiToken $testApiToken -OrganizationalUnit $testOrganizationalUnit

        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And `
                $Uri -eq "//unit.test/organizationalunits/$testOrganizationalUnitId" -And `
                $Method -eq 'Delete'
        }
    }
}
