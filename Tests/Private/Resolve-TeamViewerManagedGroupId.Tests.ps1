BeforeAll {
    $Script:Module_RootPath = (Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..\..'))
    $Script:Module_PrivCmdletsPath = Join-Path -Path $Module_RootPath -ChildPath 'Cmdlets\Private'

    . (Join-Path -Path $Module_PrivCmdletsPath -ChildPath 'Resolve-TeamViewerManagedGroupId.ps1')
}

Describe 'Resolve-TeamViewerManagedGroupId' {
    It 'Returns guid from TeamViewerPS.ManagedGroup object' {
        $Id = [guid]::NewGuid()
        $group = [pscustomobject]@{ Id = $Id }
        $group.PSObject.TypeNames.Insert(0, 'TeamViewerPS.ManagedGroup')

        Resolve-TeamViewerManagedGroupId -ManagedGroup $group | Should -Be $id
    }

    It 'Converts guid string to guid' {
        $Id = [guid]::NewGuid()

        Resolve-TeamViewerManagedGroupId -ManagedGroup $id.ToString() | Should -Be $id
    }

    It 'Returns guid input unchanged' {
        $Id = [guid]::NewGuid()

        Resolve-TeamViewerManagedGroupId -ManagedGroup $Id | Should -Be $id
    }
}
