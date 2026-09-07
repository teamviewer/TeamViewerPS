BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Remove-TeamViewerOrganizationalUnit.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }

    $testAPIToken = [securestring]@{}
    $null = $testAPIToken

    $example_uuid = '7042bac2-7ce0-47c6-8c1a-fb00505bd6ed'
    $null = $example_uuid


    Mock Get-TeamViewerAPIUri { '//unit.test' }
    Mock Invoke-TeamViewerRestMethod { }
}

Describe 'Remove-TeamViewerOrganizationalUnit' {

    It 'Should call the correct API endpoint' {
        Remove-TeamViewerOrganizationalUnit -APIToken $testAPIToken -Id $example_uuid

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $APIToken -eq $testAPIToken -and `
                $Uri -eq '//unit.test/organizationalunits/' + $example_uuid -and `
                $Method -eq 'Delete' }
    }

    It 'Should accept org unit objects' {
        $testOrgUnit = @{ id = $example_uuid } | ConvertTo-TeamViewerOrganizationalUnit
        Remove-TeamViewerOrganizationalUnit -APIToken $testAPIToken -Id $testOrgUnit

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $APIToken -eq $testAPIToken -and `
                $Uri -eq '//unit.test/organizationalunits/' + $example_uuid -and `
                $Method -eq 'Delete' }
    }

    It 'Should fail for invalid identifiers' {
        { Remove-TeamViewerOrganizationalUnit -APIToken $testAPIToken -Id 'invalid1234' } | Should -Throw
    }

    It 'Should accept pipeline input' {
        $testOrgUnit = @{ id = $example_uuid } | ConvertTo-TeamViewerOrganizationalUnit
        $testOrgUnit | Remove-TeamViewerOrganizationalUnit -APIToken $testAPIToken

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $APIToken -eq $testAPIToken -and `
                $Uri -eq '//unit.test/organizationalunits/' + $example_uuid -and `
                $Method -eq 'Delete' }
    }
}
