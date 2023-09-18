BeforeAll {
    . "$PSScriptRoot/../../Docs/Cmdlets/Public/New-TeamViewerContact.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot/../../Docs/Cmdlets/Private/*.ps1") | `
        ForEach-Object { . $_.FullName }

    $testApiToken = [securestring]@{}
    $null = $testApiToken
    $mockArgs = @{}

    Mock Get-TeamViewerApiUri { '//unit.test' }
    Mock Invoke-TeamViewerRestMethod {
        $mockArgs.Body = $Body
        @{
            id      = 'c1234'
            name    = 'Test Contact 1'
            groupid = 'g5678'
        }
    }
}

Describe 'New-TeamViewerContact' {
    It 'Should call the correct API endpoint' {
        New-TeamViewerContact -ApiToken $testApiToken -Email 'unit@example.test' -Group 'g5678'
        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And `
                $Uri -eq '//unit.test/contacts' -And `
                $Method -eq 'Post' }
    }

    It 'Should include the given input parameters in the request' {
        New-TeamViewerContact -ApiToken $testApiToken -Email 'unit@example.test' -Group 'g5678'
        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $body.email | Should -Be 'unit@example.test'
        $body.groupid | Should -Be 'g5678'
    }

    It 'Should accept Group objects' {
        $testGroupObj = @{ id = 'g5678' } | ConvertTo-TeamViewerGroup
        New-TeamViewerContact -ApiToken $testApiToken -Email 'unit@example.test' -Group $testGroupObj
        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $body.email | Should -Be 'unit@example.test'
        $body.groupid | Should -Be 'g5678'
    }
}
