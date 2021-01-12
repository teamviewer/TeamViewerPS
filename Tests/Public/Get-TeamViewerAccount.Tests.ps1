BeforeAll {
    . "$PSScriptRoot/../../TeamViewerPS/Public/Get-TeamViewerAccount.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot/../../TeamViewerPS/Private/*.ps1") | `
        ForEach-Object { . $_.FullName }

    $testApiToken = [securestring]@{}
    $null = $testApiToken

    Mock Get-TeamViewerApiUri { '//unit.test' }
    Mock Invoke-TeamViewerRestMethod {
        @{
            name            = 'Unit Test'
            email           = 'unit@example.test'
            userid          = 'u1234'
            company_name    = 'ACME Corp'
            email_validated = $true
            email_language  = 'de'
        }
    }
}

Describe 'Get-TeamViewerAccount' {
    It 'Should call the correct API endpoint' {
        Get-TeamViewerAccount -ApiToken $testApiToken
        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And `
                $Uri -eq "//unit.test/account" -And `
                $Method -eq 'Get' }
    }

    It 'Should return Account object' {
        $result = Get-TeamViewerAccount -ApiToken $testApiToken
        $result | Should -Not -BeNullOrEmpty
        $result.PSObject.TypeNames | Should -Contain 'TeamViewerPS.Account'
        $result.name | Should -Be 'Unit Test'
    }
}
