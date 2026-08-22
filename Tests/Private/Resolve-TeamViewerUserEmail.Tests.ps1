BeforeAll {
    $Script:Module_RootPath = (Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..\..'))
    $Script:Module_PrivCmdletsPath = Join-Path -Path $Module_RootPath -ChildPath 'Cmdlets\Private'

    . (Join-Path -Path $Module_PrivCmdletsPath -ChildPath 'Resolve-TeamViewerUserEmail.ps1')
}

Describe 'Resolve-TeamViewerUserEmail' {
    It 'Returns null for null input' {
        Resolve-TeamViewerUserEmail -User $null | Should -BeNull
    }

    It 'Returns email from TeamViewerPS.User object' {
        $user = [pscustomobject]@{ Email = 'user@example.com' }
        $user.PSObject.TypeNames.Insert(0, 'TeamViewerPS.User')

        Resolve-TeamViewerUserEmail -User $user | Should -Be 'user@example.com'
    }

    It 'Returns string input unchanged' {
        Resolve-TeamViewerUserEmail -User 'user@example.com' | Should -Be 'user@example.com'
    }

    It 'Throws for unsupported input type' {
        { Resolve-TeamViewerUserEmail -User 123 } | Should -Throw
    }
}
