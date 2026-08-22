BeforeAll {
    $Script:Module_RootPath = (Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..\..'))
    $Script:Module_PrivCmdletsPath = Join-Path -Path $Module_RootPath -ChildPath 'Cmdlets\Private'

    . (Join-Path -Path $Module_PrivCmdletsPath -ChildPath 'Resolve-TeamViewerUserGroupMemberId.ps1')
}

Describe 'Resolve-TeamViewerUserGroupMemberId' {
    It 'Returns Id from TeamViewerPS.UserGroupMember object' {
        $member = [pscustomobject]@{ Id = 'u123456' }
        $member.PSObject.TypeNames.Insert(0, 'TeamViewerPS.UserGroupMember')

        Resolve-TeamViewerUserGroupMemberId -UserGroupMember $member | Should -Be 'u123456'
    }

    It 'Returns user id pattern unchanged' {
        Resolve-TeamViewerUserGroupMemberId -UserGroupMember 'u123456' | Should -Be 'u123456'
    }

    It 'Converts numeric string to int' {
        Resolve-TeamViewerUserGroupMemberId -UserGroupMember '42' | Should -Be 42
    }

    It 'Returns int unchanged' {
        Resolve-TeamViewerUserGroupMemberId -UserGroupMember 42 | Should -Be 42
    }
}
