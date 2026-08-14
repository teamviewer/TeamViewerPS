BeforeAll {
    $Script:Module_RootPath = (Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..\..'))
    $Script:Module_PrivCmdletsPath = Join-Path -Path $Module_RootPath -ChildPath 'Cmdlets\Private'

    . (Join-Path -Path $Module_PrivCmdletsPath -ChildPath 'Resolve-TeamViewerSsoDomainId.ps1')
}

Describe 'Resolve-TeamViewerSsoDomainId' {
    It 'Returns guid from TeamViewerPS.SsoDomain object' {
        $id = [guid]::NewGuid()
        $domain = [pscustomobject]@{ Id = $id }
        $domain.PSObject.TypeNames.Insert(0, 'TeamViewerPS.SsoDomain')

        Resolve-TeamViewerSsoDomainId -Domain $domain | Should -Be $id
    }

    It 'Converts guid string to guid' {
        $id = [guid]::NewGuid()

        Resolve-TeamViewerSsoDomainId -Domain $id.ToString() | Should -Be $id
    }

    It 'Returns guid input unchanged' {
        $id = [guid]::NewGuid()

        Resolve-TeamViewerSsoDomainId -Domain $id | Should -Be $id
    }
}
