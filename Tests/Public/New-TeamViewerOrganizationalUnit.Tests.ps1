BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\New-TeamViewerOrganizationalUnit.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | `
        ForEach-Object { . $_.FullName }

    $testApiToken = [securestring]@{}
    $null = $testApiToken
    $mockArgs = @{}
    $testOrganizationalUnitId = '1cbae0b5-8a2f-487a-a8cf-5b884787b52c'
    $testOrganizationalUnitName = 'This is a test organizational unit'
    $testOrganizationalUnitDescription = 'This is a test organizational unit description'
    $testOrganizationalUnitParentId = 'ceb86e1a-61a8-4b76-a574-692f10c1a415'

    Mock Get-TeamViewerApiUri { '//unit.test' }
    Mock Invoke-TeamViewerRestMethod {
        $mockArgs.Body = $Body
        @{
            id          = $testOrganizationalUnitId
            name        = $testOrganizationalUnitName
            description = $testOrganizationalUnitDescription
            parentid    = $testOrganizationalUnitParentId
        }
    }
}

Describe 'New-TeamViewerOrganizationalUnit' {

    It 'Should call the correct API endpoint' {
        New-TeamViewerOrganizationalUnit -ApiToken $testApiToken -Name $testOrganizationalUnitName

        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And `
                $Uri -eq '//unit.test/organizationalunits' -And `
                $Method -eq 'Post' }
    }

    It 'Should include the given name in the request' {
        New-TeamViewerOrganizationalUnit -ApiToken $testApiToken -Name $testOrganizationalUnitName

        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $body.name | Should -Be $testOrganizationalUnitName
        $body.description | Should -Be $testOrganizationalUnitDescription
        $body.parentid | Should -Be $testOrganizationalUnitParentId
    }

    It 'Should return a OrganizationalUnit object' {
        $result = New-TeamViewerOrganizationalUnit -ApiToken $testApiToken -Name $testOrganizationalUnitName -Description $testOrganizationalUnitDescription -ParentId $testOrganizationalUnitParentId
        $result | Should -Not -BeNullOrEmpty
        $result | Should -BeOfType [PSObject]
        $result.PSObject.TypeNames | Should -Contain 'TeamViewerPS.OrganizationalUnit'
        $result.id | Should -Be $testOrganizationalUnitId
        $result.name | Should -Be $testOrganizationalUnitName
        $result.description | Should -Be $testOrganizationalUnitDescription
        $result.parentid | Should -Be $testOrganizationalUnitParentId
    }
}
