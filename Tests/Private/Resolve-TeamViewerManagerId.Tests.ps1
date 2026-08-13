BeforeAll {
    $Script:Module_RootPath = (Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..\..'))
    $Script:Module_PrivCmdletsPath = Join-Path -Path $Module_RootPath -ChildPath 'Cmdlets\Private'

    . (Join-Path -Path $Module_PrivCmdletsPath -ChildPath 'Resolve-TeamViewerManagerId.ps1')
}

Describe 'Resolve-TeamViewerManagerId' {
    It 'Returns guid from TeamViewerPS.Manager object' {
        $id = [guid]::NewGuid()
        $manager = [pscustomobject]@{ Id = $id }
        $manager.PSObject.TypeNames.Insert(0, 'TeamViewerPS.Manager')

        Resolve-TeamViewerManagerId -Manager $manager | Should -Be $id
    }

    It 'Converts guid string to guid' {
        $id = [guid]::NewGuid()

        Resolve-TeamViewerManagerId -Manager $id.ToString() | Should -Be $id
    }

    It 'Returns guid input unchanged' {
        $id = [guid]::NewGuid()

        Resolve-TeamViewerManagerId -Manager $id | Should -Be $id
    }
}
