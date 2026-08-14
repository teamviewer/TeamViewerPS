BeforeAll {
    $Script:Module_RootPath = (Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..\..'))
    $Script:Module_PrivCmdletsPath = Join-Path -Path $Module_RootPath -ChildPath 'Cmdlets\Private'

    . (Join-Path -Path $Module_PrivCmdletsPath -ChildPath 'ConvertTo-TeamViewerRoleAssignedUser.ps1')
}

Describe 'ConvertTo-TeamViewerRoleAssignedUser' {
    It 'Trims leading u from user id input' {
        $result = 'u12345' | ConvertTo-TeamViewerRoleAssignedUser

        $result.PSObject.TypeNames[0] | Should -Be 'TeamViewerPS.RoleAssignedUser'
        $result.AssignedUsers | Should -Be '12345'
    }
}
