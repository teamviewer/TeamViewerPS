BeforeAll {
    $Script:Module_RootPath = (Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..\..'))
    $Script:Module_PrivCmdletsPath = Join-Path -Path $Module_RootPath -ChildPath 'Cmdlets\Private'

    . (Join-Path -Path $Module_PrivCmdletsPath -ChildPath 'Resolve-TeamViewerUserId.ps1')
}

Describe 'Resolve-TeamViewerUserId' {
    It 'Returns Id from TeamViewerPS.User object' {
        $user = [pscustomobject]@{ Id = 'u123456' }
        $user.PSObject.TypeNames.Insert(0, 'TeamViewerPS.User')

        Resolve-TeamViewerUserId -User $user | Should -Be 'u123456'
    }

    It 'Returns valid user id string unchanged' {
        Resolve-TeamViewerUserId -User 'u123456' | Should -Be 'u123456'
    }

    It 'Throws for invalid user id string' {
        { Resolve-TeamViewerUserId -User '123456' } | Should -Throw
    }
}
