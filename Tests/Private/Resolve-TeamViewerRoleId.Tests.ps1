BeforeAll {
    $Script:Module_RootPath = (Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..\..'))
    $Script:Module_PrivCmdletsPath = Join-Path -Path $Module_RootPath -ChildPath 'Cmdlets\Private'

    . (Join-Path -Path $Module_PrivCmdletsPath -ChildPath 'Resolve-TeamViewerRoleId.ps1')
}

Describe 'Resolve-TeamViewerRoleId' {
    It 'Returns RoleID from TeamViewerPS.Role object' {
        $role = [pscustomobject]@{ RoleID = 'aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee' }
        $role.PSObject.TypeNames.Insert(0, 'TeamViewerPS.Role')

        Resolve-TeamViewerRoleId -Role $role | Should -Be 'aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee'
    }

    It 'Returns valid UUID string unchanged' {
        Resolve-TeamViewerRoleId -Role 'aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee' | Should -Be 'aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee'
    }

    It 'Throws for invalid role identifier' {
        { Resolve-TeamViewerRoleId -Role 'not-a-guid' } | Should -Throw
    }
}
