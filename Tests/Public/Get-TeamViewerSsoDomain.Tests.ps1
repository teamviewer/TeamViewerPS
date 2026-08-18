BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Get-TeamViewerSsoDomain.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }

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

            Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
                $ApiToken -eq $testApiToken -and $Uri -eq '//unit.test/ssoDomain' -and $Method -eq 'Get' }
        }

        It 'Should return SsoDomain objects' {
            $Result = Get-TeamViewerSsoDomain -ApiToken $testApiToken
            $Result | Should -HaveCount 2
            $Result[0].PSObject.TypeNames | Should -Contain 'TeamViewerPS.SsoDomain'
            $Result[0].Name | Should -Be 'domain1.test'
        }

    }

    Context 'Single SsoDomain' {
        BeforeAll {
            Mock Invoke-TeamViewerRestMethod { @{
                    domains = @(
                        @{ DomainId = '45e0d050-15e6-4fcb-91b2-ea4f20fe2085'; DomainName = 'domain1.test' }
                    )
                } }
        }

        It 'Should call the correct API endpoint for single domain' {
            Get-TeamViewerSsoDomain -ApiToken $testApiToken -Id '45e0d050-15e6-4fcb-91b2-ea4f20fe2085'

            Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
                $ApiToken -eq $testApiToken -and $Uri -eq '//unit.test/ssoDomain/45e0d050-15e6-4fcb-91b2-ea4f20fe2085' -and $Method -eq 'Get' }
        }

        It 'Should return a SsoDomain object' {
            $Result = Get-TeamViewerSsoDomain -ApiToken $testApiToken -Id '45e0d050-15e6-4fcb-91b2-ea4f20fe2085'
            $Result | Should -BeOfType PSObject
            $Result.PSObject.TypeNames | Should -Contain 'TeamViewerPS.SsoDomain'
        }

    }

}
