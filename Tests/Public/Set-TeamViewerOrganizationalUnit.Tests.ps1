BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Set-TeamViewerOrganizationalUnit.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | `
        ForEach-Object { . $_.FullName }

    $testApiToken = [securestring]@{}
    $null = $testApiToken
    $testOrgId = 'f6bdc642-374e-4923-aac9-6845c73e322f'
    $null = $testOrgId
    $mockArgs = @{}

    Mock Get-TeamViewerApiUri { '//unit.test' }
    Mock Invoke-TeamViewerRestMethod { $mockArgs.Body = $Body }
}

Describe 'Set-TeamViewerOrganizationalUnit' {
    It 'Should call the correct API endpoint' {
        Set-TeamViewerOrganizationalUnit -ApiToken $testApiToken -Id $testOrgId -Name 'Test Org'

        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And `
                $Uri -eq '//unit.test/organizationalunits/' + $testOrgId -And `
                $Method -eq 'Put' }
    }

    It 'Should include the given name in the request' {
        Set-TeamViewerOrganizationalUnit -ApiToken $testApiToken -Id $testOrgId -Name 'Test Org'

        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $body.name | Should -Be 'Test Org'
    }

    It 'Should include the optional description in the request' {
        Set-TeamViewerOrganizationalUnit -ApiToken $testApiToken -Id $testOrgId -Description 'test dec'

        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $body.description | Should -Be 'test dec'
    }

    It 'Should include the optional parent ID in the request' {
        Set-TeamViewerOrganizationalUnit -ApiToken $testApiToken -Id $testOrgId -ParentId $testOrgId

        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $body.ParentId | Should -Be $testOrgId
    }

    It 'Should accept OrgUnit object as input' {
        $testGroupObj = @{ id = $testOrgId } | ConvertTo-TeamViewerOrganizationalUnit
        Set-TeamViewerOrganizationalUnit -ApiToken $testApiToken -Id $testGroupObj

        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And `
                $Uri -eq '//unit.test/organizationalunits/' + $testOrgId -And `
                $Method -eq 'Put' }
    }

    It 'Should accept pipeline objects' {
        $testGroupObj = @{ id = $testOrgId } | ConvertTo-TeamViewerOrganizationalUnit
        $testGroupObj | Set-TeamViewerOrganizationalUnit -ApiToken $testApiToken -Name 'Unit Test Name'

        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And `
                $Uri -eq '//unit.test/organizationalunits/' + $testOrgId -And `
                $Method -eq 'Put' }
    }

    It 'Should throw if input is not a UUID' {
        { Set-TeamViewerOrganizationalUnit `
                -ApiToken $testApiToken `
                Id 'g1234' `
        } | Should -Throw
    }
}
