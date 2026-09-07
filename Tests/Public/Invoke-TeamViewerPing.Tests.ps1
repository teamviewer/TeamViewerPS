BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Invoke-TeamViewerPing.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }

    $testAPIToken = [securestring]@{}
    $null = $testAPIToken

    Mock Get-TeamViewerAPIUri { '//unit.test' }
    Mock Invoke-TeamViewerRestMethod { @{ token_valid = $true } }
}

Describe 'Invoke-TeamViewerPing' {

    It 'Should call the correct API endpoint' {
        Invoke-TeamViewerPing -APIToken $testAPIToken

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $APIToken -eq $testAPIToken -and $Uri -eq '//unit.test/ping' -and $Method -eq 'Get' }
    }

    It 'Should evaluate the token validity' {
        Mock Invoke-TeamViewerRestMethod { @{ token_valid = $true } }

        $Result = Invoke-TeamViewerPing -APIToken $testAPIToken
        $Result | Should -Be $true

        Mock Invoke-TeamViewerRestMethod { @{ token_valid = $false } }

        $Result = Invoke-TeamViewerPing -APIToken $testAPIToken
        $Result | Should -Be $false
    }
}
