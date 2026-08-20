BeforeAll {
    $Script:Module_RootPath = (Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..\..'))
    $Script:Module_PrivCmdletsPath = Join-Path -Path $Module_RootPath -ChildPath 'Cmdlets\Private'

    . (Join-Path -Path $Module_PrivCmdletsPath -ChildPath 'ConvertTo-TeamViewerUserGroupAssignedRole.ps1')
}

Describe 'ConvertTo-TeamViewerUserGroupAssignedRole' {
    It 'Creates TeamViewerPS.UserGroupAssignedRole object' {
        $Result = 'g12345' | ConvertTo-TeamViewerRoleAssignedUserGroup

        $Result.PSObject.TypeNames[0] | Should -Be 'TeamViewerPS.UserGroupAssignedRole'
        $Result.Assigned_UserGroups | Should -Be 'g12345'
    }
}
