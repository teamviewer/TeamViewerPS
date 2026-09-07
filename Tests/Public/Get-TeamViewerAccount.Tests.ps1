BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Get-TeamViewerAccount.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }

    $testAPIToken = [securestring]@{}
    $null = $testAPIToken

    Mock Get-TeamViewerAPIUri { '//unit.test' }
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
        Get-TeamViewerAccount -APIToken $testAPIToken

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $APIToken -eq $testAPIToken -and $Uri -eq '//unit.test/account' -and $Method -eq 'Get' }
    }

    It 'Should return Account object' {
        $Result = Get-TeamViewerAccount -APIToken $testAPIToken
        $Result | Should -Not -BeNullOrEmpty
        $Result.PSObject.TypeNames | Should -Contain 'TeamViewerPS.Account'
        $Result.name | Should -Be 'Unit Test'
    }
}
