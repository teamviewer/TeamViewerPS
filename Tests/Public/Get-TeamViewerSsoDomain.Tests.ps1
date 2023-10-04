BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Get-TeamViewerSsoDomain.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | `
        ForEach-Object { . $_.FullName }

    $testApiToken = [securestring]@{}
    $null = $testApiToken

    Mock Get-TeamViewerApiUri { '//unit.test' }
    Mock Invoke-TeamViewerRestMethod {
        @{
            domains = @(
                @{ DomainId = '45e0d050-15e6-4fcb-91b2-ea4f20fe2085'; DomainName = 'domain1.test' },
                @{ DomainId = 'b610124c-14b9-4b37-a2a4-a5ef678e16ed'; DomainName = 'domain2.test' }
            )
        }
    }
}

Describe 'Get-TeamViewerSsoDomain' {
    It 'Should call the correct API endpoint' {
        Get-TeamViewerSsoDomain -ApiToken $testApiToken
        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And `
                $Uri -eq "//unit.test/ssoDomain" -And `
                $Method -eq 'Get' }
    }

    It 'Should return SsoDomain objects' {
        $result = Get-TeamViewerSsoDomain -ApiToken $testApiToken
        $result | Should -HaveCount 2
        $result[0].PSObject.TypeNames | Should -Contain 'TeamViewerPS.SsoDomain'
        $result[0].Name | Should -Be 'domain1.test'
    }
}
