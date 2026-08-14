BeforeAll {
    $Script:Module_RootPath = (Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..\..'))
    $Script:Module_PrivCmdletsPath = Join-Path -Path $Module_RootPath -ChildPath 'Cmdlets\Private'

    . (Join-Path -Path $Module_PrivCmdletsPath -ChildPath 'Resolve-TeamViewerGroupId.ps1')
}

Describe 'Resolve-TeamViewerGroupId' {
    It 'Returns Id from TeamViewerPS.Group object' {
        $group = [pscustomobject]@{ Id = 'g123456' }
        $group.PSObject.TypeNames.Insert(0, 'TeamViewerPS.Group')

        Resolve-TeamViewerGroupId -Group $group | Should -Be 'g123456'
    }

    It 'Returns valid group id string unchanged' {
        Resolve-TeamViewerGroupId -Group 'g123456' | Should -Be 'g123456'
    }

    It 'Throws for invalid group id string' {
        { Resolve-TeamViewerGroupId -Group '123456' } | Should -Throw
    }
}
