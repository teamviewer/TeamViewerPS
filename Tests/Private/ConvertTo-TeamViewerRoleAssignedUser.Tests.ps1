BeforeAll {
    $Script:Module_RootPath = (Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..\..'))
    $Script:Module_PrivCmdletsPath = Join-Path -Path $Module_RootPath -ChildPath 'Cmdlets\Private'

    . (Join-Path -Path $Module_PrivCmdletsPath -ChildPath 'ConvertTo-TeamViewerRoleAssignedUser.ps1')
}

Describe 'ConvertTo-TeamViewerRoleAssignedUser' {
    It 'Trims leading u from user id input' {
        $Result = 'u12345' | ConvertTo-TeamViewerRoleAssignedUser

        $Result.PSObject.TypeNames[0] | Should -Be 'TeamViewerPS.RoleAssignedUser'
        $Result.User_Id | Should -Be 'u12345'
    }
}
