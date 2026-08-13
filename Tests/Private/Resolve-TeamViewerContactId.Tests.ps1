BeforeAll {
    $Script:Module_RootPath = (Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..\..'))
    $Script:Module_PrivCmdletsPath = Join-Path -Path $Module_RootPath -ChildPath 'Cmdlets\Private'

    . (Join-Path -Path $Module_PrivCmdletsPath -ChildPath 'Resolve-TeamViewerContactId.ps1')
}

Describe 'Resolve-TeamViewerContactId' {
    It 'Returns Id from TeamViewerPS.Contact object' {
        $contact = [pscustomobject]@{ Id = 'c123456' }
        $contact.PSObject.TypeNames.Insert(0, 'TeamViewerPS.Contact')

        Resolve-TeamViewerContactId -Contact $contact | Should -Be 'c123456'
    }

    It 'Returns valid contact id string unchanged' {
        Resolve-TeamViewerContactId -Contact 'c123456' | Should -Be 'c123456'
    }

    It 'Throws for invalid contact id string' {
        { Resolve-TeamViewerContactId -Contact '123456' } | Should -Throw
    }
}
