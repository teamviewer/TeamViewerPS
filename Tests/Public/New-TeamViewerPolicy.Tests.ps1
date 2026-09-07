BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\New-TeamViewerPolicy.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }

    $testAPIToken = [securestring]@{}
    $null = $testAPIToken
    $mockArgs = @{}

    Mock Get-TeamViewerAPIUri { '//unit.test' }
    Mock Invoke-TeamViewerRestMethod { $mockArgs.Body = $Body }
}

Describe 'New-TeamViewerPolicy' {
    It 'Should call the correct API endpoint' {
        New-TeamViewerPolicy -APIToken $testAPIToken -Name 'Unit Test Policy'

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $APIToken -eq $testAPIToken -and $Uri -eq '//unit.test/teamviewerpolicies' -and $Method -eq 'Post' }
    }

    It 'Should include the given name in the request' {
        New-TeamViewerPolicy -APIToken $testAPIToken -Name 'Unit Test Policy' -DefaultPolicy

        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $Body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $Body.name | Should -Be 'Unit Test Policy'
        $Body.default | Should -BeTrue
    }
}
