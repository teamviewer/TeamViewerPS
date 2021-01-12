BeforeAll {
    . "$PSScriptRoot/../../TeamViewerPS/Public/Disconnect-TeamViewerApi.ps1"
}

Describe 'Disconnect-TeamViewerApi' {
    BeforeEach {
        $global:PSDefaultParameterValues["*-Teamviewer*:ApiToken"] = 'test123'
    }

    It 'Should remove the PSDefaultParameterValues for the TeamViewer cmdlets' {
        $global:PSDefaultParameterValues["*-Teamviewer*:ApiToken"] | Should -Be 'test123'
        Disconnect-TeamViewerApi
        $global:PSDefaultParameterValues["*-Teamviewer*:ApiToken"] | Should -BeNullOrEmpty
    }
}
