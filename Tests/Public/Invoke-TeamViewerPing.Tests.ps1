BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Invoke-TeamViewerPing.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }

    $testApiToken = [securestring]@{}
    $null = $testApiToken

    Mock Get-TeamViewerApiUri { '//unit.test' }
    Mock Invoke-TeamViewerRestMethod { @{ token_valid = $true } }
}

Describe 'Invoke-TeamViewerPing' {

    It 'Should call the correct API endpoint' {
        Invoke-TeamViewerPing -ApiToken $testApiToken

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -and $Uri -eq '//unit.test/ping' -and $Method -eq 'Get' }
    }

    It 'Should evaluate the token validity' {
        Mock Invoke-TeamViewerRestMethod { @{ token_valid = $true } }

        $Result = Invoke-TeamViewerPing -ApiToken $testApiToken
        $Result | Should -Be $true

        Mock Invoke-TeamViewerRestMethod { @{ token_valid = $false } }

        $Result = Invoke-TeamViewerPing -ApiToken $testApiToken
        $Result | Should -Be $false
    }
}
