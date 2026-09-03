BeforeAll {
    $Script:Module_RootPath = (Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..\..'))
    $Script:Module_PrivCmdletsPath = Join-Path -Path $Module_RootPath -ChildPath 'Cmdlets\Private'

    . (Join-Path -Path $Module_PrivCmdletsPath -ChildPath 'Resolve-TeamViewerManagerId.ps1')
}

Describe 'Resolve-TeamViewerManagerId' {
    It 'Returns guid from TeamViewerPS.Manager object' {
        $Id = [guid]::NewGuid()
        $manager = [pscustomobject]@{ Id = $Id }
        $manager.PSObject.TypeNames.Insert(0, 'TeamViewerPS.Manager')

        Resolve-TeamViewerManagerId -Manager $manager | Should -Be $id
    }

    It 'Converts guid string to guid' {
        $Id = [guid]::NewGuid()

        Resolve-TeamViewerManagerId -Manager $id.ToString() | Should -Be $id
    }

    It 'Returns guid input unchanged' {
        $Id = [guid]::NewGuid()

        Resolve-TeamViewerManagerId -Manager $Id | Should -Be $id
    }
}
