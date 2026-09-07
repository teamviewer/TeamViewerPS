BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Invoke-TeamViewerPing.ps1"
    . "$PSScriptRoot\..\..\Cmdlets\Public\Connect-TeamViewerAPI.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }

    $testAPIToken = [securestring]@{}
    $null = $testAPIToken

    Mock Invoke-TeamViewerPing { $true }
}

Describe 'Connect-TeamViewerAPI' {
    BeforeEach {
        $global:PSDefaultParameterValues.Clear()
    }

    It 'Should set the PSDefaultParameterValues for the TeamViewer cmdlets' {
        Connect-TeamViewerAPI -APIToken $testAPIToken

        $global:PSDefaultParameterValues['*-Teamviewer*:APIToken'] | Should -Be $testAPIToken

        Should -Invoke Invoke-TeamViewerPing -Scope It -Times 1 -ParameterFilter {
            $APIToken -eq $testAPIToken
        }
    }

    It 'Should not set PSDefaultParameterValues if ping fails' {
        Mock Invoke-TeamViewerPing { $false }

        Connect-TeamViewerAPI -APIToken $testAPIToken

        $global:PSDefaultParameterValues['*-Teamviewer*:APIToken'] | Should -BeNullOrEmpty
    }
}
