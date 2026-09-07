BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Set-TeamViewerCompany.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }

    $testAPIToken = [securestring]@{}
    $null = $testAPIToken
    $mockArgs = @{}

    Mock Get-TeamViewerAPIUri { '//unit.test' }
    Mock Invoke-TeamViewerRestMethod { $mockArgs.Body = $Body }
}

Describe 'Set-TeamViewerCompany' {
    It 'Should call the correct API endpoint' {
        Set-TeamViewerCompany -APIToken $testAPIToken -Name 'Updated TeamViewer Germany GmbH'

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $APIToken -eq $testAPIToken -and $Uri -eq '//unit.test/company' -and $Method -eq 'Put' }
    }

    It 'Should change company name' {
        Set-TeamViewerCompany -APIToken $testAPIToken -Name 'Updated TeamViewer Germany GmbH'

        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $Body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $Body.name | Should -Be 'Updated TeamViewer Germany GmbH'
    }

    It 'Should accept changes as hashtable' {
        Set-TeamViewerCompany -APIToken $testAPIToken -Property @{ name = 'Updated TeamViewer Germany GmbH' }

        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $Body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $Body.name | Should -Be 'Updated TeamViewer Germany GmbH'
    }

    It 'Should throw if input does not contain any valid change' {
        { Set-TeamViewerCompany -APIToken $testAPIToken } | Should -Throw
    }
}
