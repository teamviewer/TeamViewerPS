BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Remove-TeamViewerOrganizationalUnit.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | `
        ForEach-Object { . $_.FullName }

    $testApiToken = [securestring]@{}
    $null = $testApiToken

    $example_uuid = '7042bac2-7ce0-47c6-8c1a-fb00505bd6ed'
    $null = $example_uuid


    Mock Get-TeamViewerApiUri { '//unit.test' }
    Mock Invoke-TeamViewerRestMethod { }
}

Describe 'Remove-TeamViewerUser' {
    It 'Should call the correct API endpoint' {
        Remove-TeamViewerOrganizationalUnit -ApiToken $testApiToken -Id $example_uuid

        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And `
                $Uri -eq '//unit.test/organizationalunits/' + $example_uuid -And `
                $Method -eq 'Delete' }
    }

    It 'Should accept org unit objects' {
        $testOrgUnit = @{ id = $example_uuid } | ConvertTo-TeamViewerOrganizationalUnit
        Remove-TeamViewerOrganizationalUnit -ApiToken $testApiToken -Id $testOrgUnit

        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And `
                $Uri -eq '//unit.test/organizationalunits/' + $example_uuid -And `
                $Method -eq 'Delete' }
    }

    It 'Should fail for invalid identifiers' {
        { Remove-TeamViewerOrganizationalUnit -ApiToken $testApiToken -Id 'invalid1234' } | Should -Throw
    }

    It 'Should accept pipeline input' {
        $testOrgUnit = @{ id = $example_uuid } | ConvertTo-TeamViewerOrganizationalUnit
        $testOrgUnit | Remove-TeamViewerOrganizationalUnit -ApiToken $testApiToken

        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And `
                $Uri -eq '//unit.test/organizationalunits/' + $example_uuid -And `
                $Method -eq 'Delete' }
    }

}
