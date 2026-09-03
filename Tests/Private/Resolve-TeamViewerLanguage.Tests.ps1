BeforeAll {
    $Script:Module_RootPath = (Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..\..'))
    $Script:Module_PrivCmdletsPath = Join-Path -Path $Module_RootPath -ChildPath 'Cmdlets\Private'

    . (Join-Path -Path $Module_PrivCmdletsPath -ChildPath 'Resolve-TeamViewerLanguage.ps1')
}

Describe 'Resolve-TeamViewerLanguage' {
    It 'Returns supported language string unchanged' {
        Resolve-TeamViewerLanguage -InputObject 'de' | Should -Be 'de'
    }

    It 'Maps zh-CN culture to zh_CN' {
        Resolve-TeamViewerLanguage -InputObject ([cultureinfo]'zh-CN') | Should -Be 'zh_CN'
    }

    It 'Maps standard culture to two-letter code' {
        Resolve-TeamViewerLanguage -InputObject ([cultureinfo]'de-DE') | Should -Be 'de'
    }

    It 'Throws for unsupported language' {
        { Resolve-TeamViewerLanguage -InputObject 'xx' } | Should -Throw
    }
}
