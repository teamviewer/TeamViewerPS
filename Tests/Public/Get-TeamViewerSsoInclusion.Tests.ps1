BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Get-TeamViewerSsoInclusion.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }

    $testApiToken = [securestring]@{}
    $null = $testApiToken
    $testDomainId = '45e0d050-15e6-4fcb-91b2-ea4f20fe2085'
    $null = $testDomainId

    Mock Get-TeamViewerApiUri { '//unit.test' }
    Mock Invoke-TeamViewerRestMethod {
        @{
            emails = @(
                'test1@example.com',
                'test2@example.com',
                'test3@example.com'
            )
        }
    }
}

Describe 'Get-TeamViewerSsoInclusion' {
    It 'Should call the correct API endpoint' {
        Get-TeamViewerSsoInclusion -ApiToken $testApiToken -DomainId $testDomainId

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -and $Uri -eq "//unit.test/ssoDomain/$testDomainId/inclusion" -and $Method -eq 'Get' }
    }

    It 'Should return included email addresses' {
        $Result = Get-TeamViewerSsoInclusion -ApiToken $testApiToken -DomainId $testDomainId
        $Result | Should -HaveCount 3
        $Result | Should -Contain 'test1@example.com'
        $Result | Should -Contain 'test2@example.com'
        $Result | Should -Contain 'test3@example.com'
    }

    It 'Should fetch consecutive pages' {
        Mock Invoke-TeamViewerRestMethod { @{
                continuation_token = 'abc'
                emails             = @(
                    'test4@example.com',
                    'test5@example.com',
                    'test6@example.com'
                )
            } }

        Mock Invoke-TeamViewerRestMethod { @{
                emails = @(
                    'test7@example.com'
                )
            } } -ParameterFilter { $Body -and $Body['ct'] -eq 'abc' }

        $Result = Get-TeamViewerSsoInclusion -ApiToken $testApiToken -DomainId $testDomainId
        $Result | Should -HaveCount 4
        $Result | Should -Contain 'test4@example.com'
        $Result | Should -Contain 'test5@example.com'
        $Result | Should -Contain 'test6@example.com'
        $Result | Should -Contain 'test7@example.com'

        Should -Invoke Invoke-TeamViewerRestMethod -Times 2 -Scope It
    }

    It 'Should handle domain objects as input' {
        $testDomain = @{DomainId = $testDomainId; DomainName = 'test managed group' } | ConvertTo-TeamViewerSsoDomain
        $Result = Get-TeamViewerSsoInclusion -ApiToken $testApiToken -Domain $testDomain
        $Result | Should -HaveCount 3

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -and $Uri -eq "//unit.test/ssoDomain/$testDomainId/inclusion" -and $Method -eq 'Get' }
    }

    It 'Should handle domain objects as input' {
        $testDomain = @{DomainId = $testDomainId; DomainName = 'test managed group' } | ConvertTo-TeamViewerSsoDomain
        $Result = Get-TeamViewerSsoInclusion -ApiToken $testApiToken -Domain $testDomain
        $Result | Should -HaveCount 3

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -and $Uri -eq "//unit.test/ssoDomain/$testDomainId/inclusion" -and $Method -eq 'Get' }
    }
}
