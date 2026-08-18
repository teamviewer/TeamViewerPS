BeforeAll {
    $Script:Module_RootPath = (Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..\..'))
    $Script:Module_PrivCmdletsPath = Join-Path -Path $Module_RootPath -ChildPath 'Cmdlets\Private'

    . (Join-Path -Path $Module_PrivCmdletsPath -ChildPath 'ConvertTo-TeamViewerRoleAssignedUserGroup.ps1')
}

Describe 'ConvertTo-TeamViewerRoleAssignedUserGroup' {
    It 'Maps assigned group input unchanged' {
        $Result = 'g12345' | ConvertTo-TeamViewerRoleAssignedUserGroup

        $Result.PSObject.TypeNames[0] | Should -Be 'TeamViewerPS.RoleAssignedUserGroup'
        $Result.AssignedGroups | Should -Be 'g12345'
    }
}
