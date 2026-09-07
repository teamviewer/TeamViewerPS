BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Get-TeamViewerSSOExclusion.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }

    $testAPIToken = [securestring]@{}
    $null = $testAPIToken
    $testDomainId = '45e0d050-15e6-4fcb-91b2-ea4f20fe2085'
    $null = $testDomainId

    Mock Get-TeamViewerAPIUri { '//unit.test' }
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

Describe 'Get-TeamViewerSSOExclusion' {
    It 'Should call the correct API endpoint' {
        Get-TeamViewerSSOExclusion -APIToken $testAPIToken -DomainId $testDomainId

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $APIToken -eq $testAPIToken -and $Uri -eq "//unit.test/ssoDomain/$testDomainId/exclusion" -and $Method -eq 'Get' }
    }

    It 'Should return excluded email addresses' {
        $Result = Get-TeamViewerSSOExclusion -APIToken $testAPIToken -DomainId $testDomainId
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

        $Result = Get-TeamViewerSSOExclusion -APIToken $testAPIToken -DomainId $testDomainId

        $Result | Should -HaveCount 4
        $Result | Should -Contain 'test4@example.com'
        $Result | Should -Contain 'test5@example.com'
        $Result | Should -Contain 'test6@example.com'
        $Result | Should -Contain 'test7@example.com'

        Should -Invoke Invoke-TeamViewerRestMethod -Times 2 -Scope It
    }

    It 'Should handle domain objects as input' {
        $testDomain = @{DomainId = $testDomainId; DomainName = 'test managed group' } | ConvertTo-TeamViewerSSODomain
        $Result = Get-TeamViewerSSOExclusion -APIToken $testAPIToken -Domain $testDomain
        $Result | Should -HaveCount 3

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $APIToken -eq $testAPIToken -and $Uri -eq "//unit.test/ssoDomain/$testDomainId/exclusion" -and $Method -eq 'Get' }
    }
}
