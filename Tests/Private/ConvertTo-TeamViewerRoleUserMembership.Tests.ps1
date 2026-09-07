BeforeAll {
    $Script:Module_RootPath = (Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..\..'))
    $Script:Module_PrivCmdletsPath = Join-Path -Path $Module_RootPath -ChildPath 'Cmdlets\Private'

    . (Join-Path -Path $Module_PrivCmdletsPath -ChildPath 'ConvertTo-TeamViewerRoleUserMembership.ps1')
}

Describe 'ConvertTo-TeamViewerRoleUserMembership' {
    It 'Trims leading u from user id input' {
        $Result = 'u12345' | ConvertTo-TeamViewerRoleUserMembership

        $Result.PSObject.TypeNames[0] | Should -Be 'TeamViewerPS.RoleUserMembership'
        $Result.UserId | Should -Be 'u12345'
    }
}
