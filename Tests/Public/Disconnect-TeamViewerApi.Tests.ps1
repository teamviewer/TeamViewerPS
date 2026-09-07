BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Disconnect-TeamViewerAPI.ps1"
}

Describe 'Disconnect-TeamViewerAPI' {
    BeforeEach {
        $global:PSDefaultParameterValues["*-Teamviewer*:APIToken"] = 'test123'
    }

    It 'Should remove the PSDefaultParameterValues for the TeamViewer cmdlets' {
        $global:PSDefaultParameterValues["*-Teamviewer*:APIToken"] | Should -Be 'test123'
        Disconnect-TeamViewerAPI
        $global:PSDefaultParameterValues["*-Teamviewer*:APIToken"] | Should -BeNullOrEmpty
    }
}
