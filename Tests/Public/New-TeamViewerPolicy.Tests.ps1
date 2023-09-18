BeforeAll {
    . "$PSScriptRoot/../../docs/Cmdlets/Public/New-TeamViewerPolicy.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot/../../docs/Cmdlets/Private/*.ps1") | `
        ForEach-Object { . $_.FullName }

    $testApiToken = [securestring]@{}
    $null = $testApiToken
    $mockArgs = @{}

    Mock Get-TeamViewerApiUri { '//unit.test' }
    Mock Invoke-TeamViewerRestMethod { $mockArgs.Body = $Body }
}

Describe 'New-TeamViewerPolicy' {
    It 'Should call the correct API endpoint' {
        New-TeamViewerPolicy -ApiToken $testApiToken -Name 'Unit Test Policy'

        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And `
                $Uri -eq '//unit.test/teamviewerpolicies' -And `
                $Method -eq 'Post' }
    }

    It 'Should include the given name in the request' {
        New-TeamViewerPolicy `
            -ApiToken $testApiToken `
            -Name 'Unit Test Policy' `
            -DefaultPolicy

        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $body.name | Should -Be 'Unit Test Policy'
        $body.default | Should -BeTrue
    }
}
