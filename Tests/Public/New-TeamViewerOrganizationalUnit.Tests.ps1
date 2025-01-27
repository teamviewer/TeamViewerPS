BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\New-TeamViewerOrganizationalUnit.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | `
        ForEach-Object { . $_.FullName }

    $testApiToken = [securestring]@{}
    $null = $testApiToken
    $mockArgs = @{}

    Mock Get-TeamViewerApiUri { '//unit.test' }
    Mock Invoke-TeamViewerRestMethod { $mockArgs.Body = $Body }
}

Describe 'New-TeamViewerOrganizationalUnit' {

    It 'Should call the correct API endpoint' {
        New-TeamViewerOrganizationalUnit -ApiToken $testApiToken -Name '1st organizational unit'

        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And $Uri -eq '//unit.test/organizationalunits' -And $Method -eq 'Post'
        }
    }

    It 'Should include the given name in the request' {
        New-TeamViewerOrganizationalUnit -ApiToken $testApiToken -Name '1st organizational unit' -Description 'Description of 1st organizational unit' -Parent '1cbae0b5-8a2f-487a-a8cf-5b884787b52c'

        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $body.name | Should -Be '1st organizational unit'
        $body.description | Should -Be 'Description of 1st organizational unit'
        $body.parent | Should -Be '1cbae0b5-8a2f-487a-a8cf-5b884787b52c'
    }
}
