BeforeAll {
    . "$PSScriptRoot/../../docs/Cmdlets/Public/Invoke-TeamViewerPing.ps1"
    . "$PSScriptRoot/../../docs/Cmdlets/Public/Connect-TeamViewerApi.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot/../../docs/Cmdlets/Private/*.ps1") | `
        ForEach-Object { . $_.FullName }

    $testApiToken = [securestring]@{}
    $null = $testApiToken

    Mock Invoke-TeamViewerPing { $true }
}

Describe 'Connect-TeamViewerApi' {
    BeforeEach {
        $global:PSDefaultParameterValues.Clear()
    }

    It 'Should set the PSDefaultParameterValues for the TeamViewer cmdlets' {
        Connect-TeamViewerApi -ApiToken $testApiToken
        $global:PSDefaultParameterValues["*-Teamviewer*:ApiToken"] | Should -Be $testApiToken

        Assert-MockCalled Invoke-TeamViewerPing -Scope It -Times 1 -ParameterFilter {
            $ApiToken -eq $testApiToken
        }
    }

    It 'Should not set PSDefaultParameterValues if ping fails' {
        Mock Invoke-TeamViewerPing { $false }
        Connect-TeamViewerApi -ApiToken $testApiToken
        $global:PSDefaultParameterValues["*-Teamviewer*:ApiToken"] | Should -BeNullOrEmpty
    }
}
