BeforeAll {
    . "$PSScriptRoot/../../TeamViewerPS/Public/Remove-TeamViewerContact.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot/../../TeamViewerPS/Private/*.ps1") | `
        ForEach-Object { . $_.FullName }

    $testApiToken = [securestring]@{}
    $null = $testApiToken

    Mock Get-TeamViewerApiUri { '//unit.test' }
    Mock Invoke-TeamViewerRestMethod { }
}

Describe 'Remove-TeamViewerContact' {
    It 'Should call the correct API endpoint' {
        Remove-TeamViewerContact -ApiToken $testApiToken -Id 'c1234'
        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And `
                $Uri -eq '//unit.test/contacts/c1234' -And `
                $Method -eq 'Delete' }
    }

    It 'Should accept Contact objects' {
        $testContact = @{ contact_id = 'c1234' } | ConvertTo-TeamViewerContact
        Remove-TeamViewerContact -ApiToken $testApiToken -Contact $testContact
        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And `
                $Uri -eq '//unit.test/contacts/c1234' -And `
                $Method -eq 'Delete' }
    }

    It 'Should accept pipeline input' {
        $testContact = @{ contact_id = 'c1234' } | ConvertTo-TeamViewerContact
        $testContact | Remove-TeamViewerContact -ApiToken $testApiToken
        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And `
                $Uri -eq '//unit.test/contacts/c1234' -And `
                $Method -eq 'Delete' }
    }
}
