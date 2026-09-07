BeforeAll {
    $Script:Module_RootPath = (Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..\..'))
    $Script:Module_PrivCmdletsPath = Join-Path -Path $Module_RootPath -ChildPath 'Cmdlets\Private'

    . (Join-Path -Path $Module_PrivCmdletsPath -ChildPath 'ConvertTo-TeamViewerRoleUserGroupMembership.ps1')
}

Describe 'ConvertTo-TeamViewerRoleUserGroupMembership' {
    It 'Maps group input unchanged' {
        $Result = 'g12345' | ConvertTo-TeamViewerRoleUserGroupMembership

        $Result.PSObject.TypeNames[0] | Should -Be 'TeamViewerPS.RoleUserGroupMembership'
        $Result.UserGroupId | Should -Be 'g12345'
    }
}
