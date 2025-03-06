BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Set-TeamViewerOrganizationalUnit.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | `
        ForEach-Object { . $_.FullName }

    $testApiToken = [securestring]@{}
    $null = $testApiToken
    $mockArgs = @{}
    $testOrganizationalUnitId = '1cbae0b5-8a2f-487a-a8cf-5b884787b52c'
    $testOrganizationalUnitName = 'This is a test organizational unit'
    $testOrganizationalUnitDescription = 'This is a test organizational unit description'
    $testOrganizationalUnitParentId = '5462594a-48ce-8d45-0bee-17296931b0b5'

    Mock Get-TeamViewerApiUri { '//unit.test' }
    Mock Invoke-TeamViewerRestMethod {
        $mockArgs.Body = $Body
        @{
            Id          = $testOrganizationalUnitId
            Name        = $testOrganizationalUnitName
            Description = $testOrganizationalUnitDescription
            ParentId    = $testOrganizationalUnitParentId
        }
    }
}

Describe 'Set-TeamViewerOrganizationalUnit' {

    It 'Should call the correct API endpoint' {
        Set-TeamViewerOrganizationalUnit `
            -ApiToken $testApiToken `
            -Id $testOrganizationalUnitId `
            -Name $testOrganizationalUnitName `
            -Description $testOrganizationalUnitDescription `
            -ParentId = $testOrganizationalUnitParentId

        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And `
                $Uri -eq "//unit.test/organizationalunits/$testOrganizationalUnitId" -And `
                $Method -eq 'Put' }
    }

    It 'Should handle domain object as input' {
        $testOrganizationalUnit = @{Id = $testOrganizationalUnitId; Name = 'test organizational unit' ; Description = 'This is a test organizational unit description'; ParentId = '5462594a-48ce-8d45-0bee-17296931b0b5' } | ConvertTo-TeamViewerOrganizationalUnit
        Set-TeamViewerOrganizationalUnit `
            -ApiToken $testApiToken `
            -OrganizationalUnit $testOrganizationalUnit `
            -Name $testOrganizationalUnitName `
            -Description $testOrganizationalUnitDescription `
            -ParentId = $testOrganizationalUnitParentId

        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And `
                $Uri -eq "//unit.test/organizationalunits/$testOrganizationalUnitId" -And `
                $Method -eq 'Put' }
    }

    It 'Should include the given name in the request' {
        Set-TeamViewerOrganizationalUnit `
            -ApiToken $testApiToken `
            -OrganizationalUnit $testOrganizationalUnitId `
            -Name $testOrganizationalUnitName `
            -Description $testOrganizationalUnitDescription `
            -ParentId = $testOrganizationalUnitParentId

        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $body.name | Should -Be $testOrganizationalUnitName
    }

    It 'Should return a OrganizationalUnit object' {
        $result = Set-TeamViewerOrganizationalUnit `
            -ApiToken $testApiToken `
            -Id $testOrganizationalUnitId `
            -Name $testOrganizationalUnitName `
            -Description $testOrganizationalUnitDescription `
            -ParentId = $testOrganizationalUnitParentId

        $result | Should -Not -BeNullOrEmpty
        $result | Should -BeOfType [PSObject]
        $result.PSObject.TypeNames | Should -Contain 'TeamViewerPS.OrganizationalUnit'
        $result.Id | Should -Be $testOrganizationalUnitId
        $result.Name | Should -Be $testOrganizationalUnitName
        $result.Description | Should -Be $testOrganizationalUnitDescription
        $result.ParentId = $testOrganizationalUnitParentId
    }
}
