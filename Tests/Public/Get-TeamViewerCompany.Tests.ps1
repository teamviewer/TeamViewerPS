BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Get-TeamViewerCompany.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }

    $testApiToken = [securestring]@{}
    $null = $testApiToken

    Mock Get-TeamViewerApiUri { '//unit.test' }
    Mock Invoke-TeamViewerRestMethod {
        @{
            companyId   = 42
            companyName = 'TeamViewer Germany GmbH'
        }
    }
}

Describe 'Get-TeamViewerCompany' {
    It 'Should call the correct API endpoint' {
        Get-TeamViewerCompany -ApiToken $testApiToken

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -and $Uri -eq '//unit.test/company' -and $Method -eq 'Get' }
    }

    It 'Should return Company object' {
        $Result = Get-TeamViewerCompany -ApiToken $testApiToken
        $Result | Should -Not -BeNullOrEmpty
        $Result.PSObject.TypeNames | Should -Contain 'TeamViewerPS.Company'
        $Result.Id | Should -Be 42
        $Result.Name | Should -Be 'TeamViewer Germany GmbH'
    }
}
