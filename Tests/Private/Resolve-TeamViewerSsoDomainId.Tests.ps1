BeforeAll {
    $Script:Module_RootPath = (Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..\..'))
    $Script:Module_PrivCmdletsPath = Join-Path -Path $Module_RootPath -ChildPath 'Cmdlets\Private'

    . (Join-Path -Path $Module_PrivCmdletsPath -ChildPath 'Resolve-TeamViewerSSODomainId.ps1')
}

Describe 'Resolve-TeamViewerSSODomainId' {
    It 'Returns guid from TeamViewerPS.SSODomain object' {
        $Id = [guid]::NewGuid()
        $domain = [pscustomobject]@{ Id = $Id }
        $domain.PSObject.TypeNames.Insert(0, 'TeamViewerPS.SSODomain')

        Resolve-TeamViewerSSODomainId -Domain $domain | Should -Be $id
    }

    It 'Converts guid string to guid' {
        $Id = [guid]::NewGuid()

        Resolve-TeamViewerSSODomainId -Domain $id.ToString() | Should -Be $id
    }

    It 'Returns guid input unchanged' {
        $Id = [guid]::NewGuid()

        Resolve-TeamViewerSSODomainId -Domain $Id | Should -Be $id
    }
}
