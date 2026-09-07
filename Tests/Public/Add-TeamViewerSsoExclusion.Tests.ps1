BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Add-TeamViewerSSOExclusion.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }

    $testAPIToken = [securestring]@{}
    $null = $testAPIToken
    $testDomainId = '45e0d050-15e6-4fcb-91b2-ea4f20fe2085'
    $null = $testDomainId

    Mock Get-TeamViewerAPIUri { '//unit.test' }
    $mockArgs = @{}
    Mock Invoke-TeamViewerRestMethod { $mockArgs.Body = $Body }
}

Describe 'Add-TeamViewerSSOExclusion' {
    It 'Should call the correct API endpoint' {
        Add-TeamViewerSSOExclusion -APIToken $testAPIToken -DomainId $testDomainId -Email 'foo@example.test'

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $APIToken -eq $testAPIToken -and $Uri -eq "//unit.test/ssoDomain/$testDomainId/exclusion" -and $Method -eq 'Post' }
    }

    It 'Should add the given emails to the exclusion list' {
        Add-TeamViewerSSOExclusion -APIToken $testAPIToken -DomainId $testDomainId -Email 'foo@example.test', 'bar@example.test'

        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $Body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $Body.emails | Should -Contain 'foo@example.test'
        $Body.emails | Should -Contain 'bar@example.test'
    }

    It 'Should accept pipeline input' {
        @('foo@example.test', 'bar@example.test') | Add-TeamViewerSSOExclusion -APIToken $testAPIToken -DomainId $testDomainId
        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $Body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $Body.emails | Should -Contain 'foo@example.test'
        $Body.emails | Should -Contain 'bar@example.test'
    }

    It 'Should handle domain objects as input' {
        $testDomain = @{DomainId = $testDomainId; DomainName = 'test managed group' } | ConvertTo-TeamViewerSSODomain

        Add-TeamViewerSSOExclusion -APIToken $testAPIToken -Domain $testDomain -Email 'foo@example.test'

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $APIToken -eq $testAPIToken -and $Uri -eq "//unit.test/ssoDomain/$testDomainId/exclusion" -and $Method -eq 'Post' }
    }

    It 'Should create bulks' {
        $testAddresses = @()
        1..250 | ForEach-Object { $testAddresses += "foo$_@example.test" }

        $testAddresses | Add-TeamViewerSSOExclusion -APIToken $testAPIToken -DomainId $testDomainId

        Should -Invoke Invoke-TeamViewerRestMethod -Times 3 -Scope It

        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $Body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $Body.emails | Should -HaveCount 50
    }
}
