BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Add-TeamViewerSsoInclusion.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | `
        ForEach-Object { . $_.FullName }

    $testApiToken = [securestring]@{}
    $null = $testApiToken
    $testDomainId = '45e0d050-15e6-4fcb-91b2-ea4f20fe2085'
    $null = $testDomainId

    Mock Get-TeamViewerApiUri { '//unit.test' }
    $mockArgs = @{}
    Mock Invoke-TeamViewerRestMethod { $mockArgs.Body = $Body }
}

Describe 'Add-TeamViewerSsoInclusion' {
    It 'Should call the correct API endpoint' {
        Add-TeamViewerSsoInclusion `
            -ApiToken $testApiToken `
            -DomainId $testDomainId `
            -Email 'foo@example.test'
        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And `
                $Uri -eq "//unit.test/ssoDomain/$testDomainId/inclusion" -And `
                $Method -eq 'Post' }
    }

    It 'Should add the given emails to the inclusion list' {
        Add-TeamViewerSsoInclusion `
            -ApiToken $testApiToken `
            -DomainId $testDomainId `
            -Email 'foo@example.test', 'bar@example.test'
        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $body.emails | Should -Contain 'foo@example.test'
        $body.emails | Should -Contain 'bar@example.test'
    }

    It 'Should accept pipeline input' {
        @('foo@example.test', 'bar@example.test') | Add-TeamViewerSsoInclusion `
            -ApiToken $testApiToken `
            -DomainId $testDomainId
        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $body.emails | Should -Contain 'foo@example.test'
        $body.emails | Should -Contain 'bar@example.test'
    }

    It 'Should handle domain objects as input' {
        $testDomain = @{DomainId = $testDomainId; DomainName = 'test managed group' } | ConvertTo-TeamViewerSsoDomain
        Add-TeamViewerSsoInclusion `
            -ApiToken $testApiToken `
            -Domain $testDomain `
            -Email 'foo@example.test'
        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And `
                $Uri -eq "//unit.test/ssoDomain/$testDomainId/inclusion" -And `
                $Method -eq 'Post' }
    }

    It 'Should create bulks' {
        $testAddresses = @()
        1..250 | ForEach-Object { $testAddresses += "foo$_@example.test" }
        $testAddresses | Add-TeamViewerSsoInclusion `
            -ApiToken $testApiToken `
            -DomainId $testDomainId
        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 3 -Scope It
        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $body.emails | Should -HaveCount 50
    }
}
