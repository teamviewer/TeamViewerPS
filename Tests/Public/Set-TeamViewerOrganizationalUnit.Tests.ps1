BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Set-TeamViewerOrganizationalUnit.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | `
        ForEach-Object { . $_.FullName }

    $testApiToken = [securestring]@{}
    $null = $testApiToken
    $mockArgs = @{}

    Mock Get-TeamViewerApiUri { '//unit.test' }
    Mock Invoke-TeamViewerRestMethod { $mockArgs.Body = $Body }
}

Describe 'Set-TeamViewerOrganizationalUnit' {
    It 'Should call the correct API endpoint' {
        Set-TeamViewerOrganizationalUnit -ApiToken $testApiToken -OrganizationalUnitId '1cbae0b5-8a2f-487a-a8cf-5b884787b52c' -Name '1st organizational unit'

        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And $Uri -eq '//unit.test/organizationalunits/1cbae0b5-8a2f-487a-a8cf-5b884787b52c' -And $Method -eq 'Put'
        }
    }

    It 'Should include the name and description in the request' {
        Set-TeamViewerOrganizationalUnit -ApiToken $testApiToken -OrganizationalUnitId '1cbae0b5-8a2f-487a-a8cf-5b884787b52c' -Name '1st organizational unit' -Description 'Description of 1st organizational unit'

        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $body.name | Should -Be '1st organizational unit'
        $body.description | Should -Be 'Description of 1st organizational unit'
    }

    It 'Should accept organizational unit objects as input' {
        $TestOrgUnit = @{ id = '1cbae0b5-8a2f-487a-a8cf-5b884787b52c' } | ConvertTo-TeamViewerOrganizationalUnit
        Set-TeamViewerOrganizationalUnit -ApiToken $testApiToken -OrganizationalUnit $TestOrgUnit -Name '1st organizational unit'

        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And $Uri -eq '//unit.test/organizationalunits/1cbae0b5-8a2f-487a-a8cf-5b884787b52c' -And $Method -eq 'Put'
        }
    }

    It 'Should accept pipeline objects' {
        $TestOrgUnit = @{ id = '1cbae0b5-8a2f-487a-a8cf-5b884787b52c' } | ConvertTo-TeamViewerOrganizationalUnit
        $TestOrgUnit | Set-TeamViewerOrganizationalUnit -ApiToken $testApiToken -Name '1st organizational unit'

        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And $Uri -eq '//unit.test/organizationalunits/1cbae0b5-8a2f-487a-a8cf-5b884787b52c' -And $Method -eq 'Put'
        }
    }

    It 'Should accept changes given as hashtable' {
        Set-TeamViewerOrganizationalUnit `
            -ApiToken $testApiToken `
            -OrganizationalUnitId '1cbae0b5-8a2f-487a-a8cf-5b884787b52c' `
            -Property @{
            name        = '1st organizational unit'
            description = 'Description of 1st organizational unit'
        }

        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $body.name | Should -Be '1st organizational unit'
        $body.description | Should -Be 'Description of 1st organizational unit'
    }

    It 'Should throw if hashtable does not contain any valid change' {
        { Set-TeamViewerOrganizationalUnit `
                -ApiToken $testApiToken `
                -OrganizationalUnitId '1cbae0b5-8a2f-487a-a8cf-5b884787b52c' `
                -Property @{
                foo = 'bar'
            } } | Should -Throw
    }
}
