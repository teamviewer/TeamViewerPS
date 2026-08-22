BeforeAll {
    $Script:Module_RootPath = (Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..\..'))
    $Script:Module_PrivCmdletsPath = Join-Path -Path $Module_RootPath -ChildPath 'Cmdlets\Private'

    . (Join-Path -Path $Module_PrivCmdletsPath -ChildPath 'Get-TeamViewerApiUri.ps1')
}

Describe 'Get-TeamViewerAPIUri' {
    It 'Returns default API URI when configuration is untouched' {
        [TeamViewerConfiguration]::Instance = $null

        Get-TeamViewerAPIUri | Should -Be 'https://webapi.teamviewer.com/api/v1'
    }

    It 'Returns configured API URI from singleton instance' {
        [TeamViewerConfiguration]::Instance = $null
        $cfg = [TeamViewerConfiguration]::GetInstance()
        $cfg.APIUri = 'https://example.local/api/v1'

        Get-TeamViewerAPIUri | Should -Be 'https://example.local/api/v1'
    }
}
