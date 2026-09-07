BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Get-TeamViewerSSODomain.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }

    $testAPIToken = [securestring]@{}
    $null = $testAPIToken

    Mock Get-TeamViewerAPIUri { '//unit.test' }

}

Describe 'Get-TeamViewerSSODomain' {
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
            Get-TeamViewerSSODomain -APIToken $testAPIToken

            Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
                $APIToken -eq $testAPIToken -and $Uri -eq '//unit.test/ssoDomain' -and $Method -eq 'Get' }
        }

        It 'Should return SSODomain objects' {
            $Result = Get-TeamViewerSSODomain -APIToken $testAPIToken
            $Result | Should -HaveCount 2
            $Result[0].PSObject.TypeNames | Should -Contain 'TeamViewerPS.SSODomain'
            $Result[0].Name | Should -Be 'domain1.test'
        }

    }

    Context 'Single SSODomain' {
        BeforeAll {
            Mock Invoke-TeamViewerRestMethod { @{
                    domains = @(
                        @{ DomainId = '45e0d050-15e6-4fcb-91b2-ea4f20fe2085'; DomainName = 'domain1.test' }
                    )
                } }
        }

        It 'Should call the correct API endpoint for single domain' {
            Get-TeamViewerSSODomain -APIToken $testAPIToken -Id '45e0d050-15e6-4fcb-91b2-ea4f20fe2085'

            Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
                $APIToken -eq $testAPIToken -and $Uri -eq '//unit.test/ssoDomain/45e0d050-15e6-4fcb-91b2-ea4f20fe2085' -and $Method -eq 'Get' }
        }

        It 'Should return a SSODomain object' {
            $Result = Get-TeamViewerSSODomain -APIToken $testAPIToken -Id '45e0d050-15e6-4fcb-91b2-ea4f20fe2085'
            $Result | Should -BeOfType ([pscustomobject])
            $Result.PSObject.TypeNames | Should -Contain 'TeamViewerPS.SSODomain'
        }

    }

}
