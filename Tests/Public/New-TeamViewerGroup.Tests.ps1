BeforeAll {
    . "$PSScriptRoot/../../Docs/Cmdlets/Public/New-TeamViewerGroup.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot/../../Docs/Cmdlets/Private/*.ps1") | `
        ForEach-Object { . $_.FullName }

    $testApiToken = [securestring]@{}
    $null = $testApiToken
    $mockArgs = @{}

    Mock Get-TeamViewerApiUri { '//unit.test' }
    Mock Invoke-TeamViewerRestMethod { $mockArgs.Body = $Body }
}

Describe 'New-TeamViewerGroup' {

    It 'Should call the correct API endpoint' {
        New-TeamViewerGroup -ApiToken $testApiToken -Name 'Unit Test Group'

        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And `
                $Uri -eq '//unit.test/groups' -And `
                $Method -eq 'Post' }
    }

    It 'Should include the given name in the request' {
        New-TeamViewerGroup -ApiToken $testApiToken -Name 'Unit Test Group'

        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $body.name | Should -Be 'Unit Test Group'
    }
}
