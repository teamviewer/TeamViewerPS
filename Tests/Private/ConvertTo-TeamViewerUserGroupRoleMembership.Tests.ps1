BeforeAll {
    $Script:Module_RootPath = (Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..\..'))
    $Script:Module_PrivCmdletsPath = Join-Path -Path $Module_RootPath -ChildPath 'Cmdlets\Private'

    . (Join-Path -Path $Module_PrivCmdletsPath -ChildPath 'ConvertTo-TeamViewerUserGroupRoleMembership.ps1')
}

Describe 'ConvertTo-TeamViewerUserGroupRoleMembership' {
    It 'Creates TeamViewerPS.UserGroupRoleMembership object' {
        $Result = 'g12345' | ConvertTo-TeamViewerUserGroupRoleMembership

        $Result.PSObject.TypeNames[0] | Should -Be 'TeamViewerPS.UserGroupRoleMembership'
        $Result.RoleId | Should -Be 'g12345'
    }
}
