BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\New-TeamViewerOrganizationalUnit.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | `
        ForEach-Object { . $_.FullName }

    $testApiToken = [securestring]@{}
    $null = $testApiToken
    $mockArgs = @{}

    Mock Get-TeamViewerApiUri { '//unit.test' }
    Mock Invoke-TeamViewerRestMethod { $mockArgs.Body = $Body
        @{
            Name        = 'Test22'
            ParentId    = 'd696ef85-d40a-479e-8331-4813f59e6481'
            Id          = 'cbe3195f-dd84-4e63-a922-fa337658d459'
            Description = ''
            CreatedAt   = '28/03/2025 16:07:16'
            UpdatedAt   = '28/03/2025 16:07:16'
        } }

}

Describe 'New-TeamViewerOrganizationalUnit' {

    It 'Should call the correct API endpoint' {
        New-TeamViewerOrganizationalUnit -ApiToken $testApiToken -Name 'Test22'

        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And $Uri -eq '//unit.test/organizationalunits' -And $Method -eq 'Post' }
    }

    It 'Should include the given name, description and parent in the request' {
        New-TeamViewerOrganizationalUnit -ApiToken $testApiToken -Name 'Unit Test' -Description 'Test' -ParentId 'd696ef85-d40a-479e-8331-4813f59e6481'

        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $body.name | Should -Be 'Unit Test'
        $body.description | Should -Be 'Test'
        $body.parentId | Should -Be 'd696ef85-d40a-479e-8331-4813f59e6481'

    }

    It 'Should return the new org unit object' {
        $result = New-TeamViewerOrganizationalUnit -ApiToken $testApiToken -Name 'Test22' -ParentId 'd696ef85-d40a-479e-8331-4813f59e6481'

        $result | Should -Not -BeNullOrEmpty
        $result.PSObject.TypeNames | Should -Contain 'TeamViewerPS.OrganizationalUnit'
        $result.name | Should -Be 'Test22'
        $result.parentId | Should -Be 'd696ef85-d40a-479e-8331-4813f59e6481'
    }


    It 'Should allow to specify a description for the new org unit' {
        $testDescription = 'Test description'

        New-TeamViewerOrganizationalUnit -ApiToken $testApiToken -Name 'Unit Test User' -Description $testDescription

        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $body.description | Should -Be $testDescription
    }


}
