BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Get-TeamViewerSsoDomain.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | `
        ForEach-Object { . $_.FullName }

    $testApiToken = [securestring]@{}
    $null = $testApiToken

    Mock Get-TeamViewerApiUri { '//unit.test' }
    
}

Describe 'Get-TeamViewerSsoDomain' {

    Context 'List' {  
       BeforeAll {
        Mock Invoke-TeamViewerRestMethod {
        @{
            domains = @(
                @{ DomainId = '45e0d050-15e6-4fcb-91b2-ea4f20fe2085'; DomainName = 'domain1.test' },
                @{ DomainId = 'b610124c-14b9-4b37-a2a4-a5ef678e16ed'; DomainName = 'domain2.test' }
            )
        } } 
    }
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

   Context 'Single SsoDomain' {  
        BeforeAll {
            Mock Invoke-TeamViewerRestMethod { @{
                    domains = @(
                        @{ Domainid = '45e0d050-15e6-4fcb-91b2-ea4f20fe2085'; DomainName = 'domain1.test' }
                    )
                } }
        }

        It 'Should call the correct API endpoint for single domain' {
            Get-TeamViewerSsoDomain -ApiToken $testApiToken -Id '45e0d050-15e6-4fcb-91b2-ea4f20fe2085'

            Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
                $ApiToken -eq $testApiToken -And `
                    $Uri -eq '//unit.test/ssoDomain/45e0d050-15e6-4fcb-91b2-ea4f20fe2085' -And `
                    $Method -eq 'Get' }
        }

        It 'Should return a SsoDomain object' {
            $result = Get-TeamViewerSsoDomain -ApiToken $testApiToken -Id '45e0d050-15e6-4fcb-91b2-ea4f20fe2085'
            $result | Should -BeOfType PSObject
            $result.PSObject.TypeNames | Should -Contain 'TeamViewerPS.SsoDomain'
        }    

   }


}
