BeforeAll {
    $Script:Module_RootPath = (Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..\..'))
    $Script:Module_PrivCmdletsPath = Join-Path -Path $Module_RootPath -ChildPath 'Cmdlets\Private'

    . (Join-Path -Path $Module_PrivCmdletsPath -ChildPath 'Resolve-TeamViewerUserGroupId.ps1')
}

Describe 'Resolve-TeamViewerUserGroupId' {
    It 'Returns UInt64 from TeamViewerPS.UserGroup object' {
        $group = [pscustomobject]@{ Id = 42 }
        $group.PSObject.TypeNames.Insert(0, 'TeamViewerPS.UserGroup')

        Resolve-TeamViewerUserGroupId -UserGroup $group | Should -Be ([uint64]42)
    }

    It 'Converts numeric string to UInt64' {
        Resolve-TeamViewerUserGroupId -UserGroup '42' | Should -Be ([uint64]42)
    }

    It 'Converts int to UInt64' {
        Resolve-TeamViewerUserGroupId -UserGroup 42 | Should -Be ([uint64]42)
    }
}
