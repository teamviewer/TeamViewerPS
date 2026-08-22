BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Set-TeamViewerCompany.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }

    $testApiToken = [securestring]@{}
    $null = $testApiToken
    $mockArgs = @{}

    Mock Get-TeamViewerApiUri { '//unit.test' }
    Mock Invoke-TeamViewerRestMethod { $mockArgs.Body = $Body }
}

Describe 'Set-TeamViewerCompany' {
    It 'Should call the correct API endpoint' {
        Set-TeamViewerCompany -ApiToken $testApiToken -Name 'Updated TeamViewer Germany GmbH'

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -and $Uri -eq '//unit.test/company' -and $Method -eq 'Put' }
    }

    It 'Should change company name' {
        Set-TeamViewerCompany -ApiToken $testApiToken -Name 'Updated TeamViewer Germany GmbH'

        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $Body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $Body.name | Should -Be 'Updated TeamViewer Germany GmbH'
    }

    It 'Should accept changes as hashtable' {
        Set-TeamViewerCompany -ApiToken $testApiToken -Property @{ name = 'Updated TeamViewer Germany GmbH' }

        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $Body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $Body.name | Should -Be 'Updated TeamViewer Germany GmbH'
    }

    It 'Should throw if input does not contain any valid change' {
        { Set-TeamViewerCompany -ApiToken $testApiToken } | Should -Throw
    }
}
