BeforeAll {
    $Script:Module_RootPath = (Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..\..'))
    $Script:Module_PrivCmdletsPath = Join-Path -Path $Module_RootPath -ChildPath 'Cmdlets\Private'

    . (Join-Path -Path $Module_PrivCmdletsPath -ChildPath 'Resolve-TeamViewerOrganizationalUnitId.ps1')
}

Describe 'Resolve-TeamViewerOrganizationalUnitId' {
    It 'Returns guid from TeamViewerPS.OrganizationalUnit object' {
        $Id = [guid]::NewGuid()
        $OrganizationalUnit = [pscustomobject]@{ Id = $Id }
        $OrganizationalUnit.PSObject.TypeNames.Insert(0, 'TeamViewerPS.OrganizationalUnit')

        Resolve-TeamViewerOrganizationalUnitId -OrganizationalUnit $OrganizationalUnit | Should -Be $Id
    }

    It 'Returns guid string unchanged' {
        $Id = [guid]::NewGuid()

        Resolve-TeamViewerOrganizationalUnitId -OrganizationalUnit $Id.ToString() | Should -Be $Id.ToString()
    }

    It 'Throws for an invalid string identifier' {
        { Resolve-TeamViewerOrganizationalUnitId -OrganizationalUnit 'not-a-uuid' } | `
            Should -Throw "Invalid organizational unit identifier 'not-a-uuid'. String must be an UUID."
    }

    It 'Throws for an unsupported identifier type' {
        { Resolve-TeamViewerOrganizationalUnitId -OrganizationalUnit 42 } | `
            Should -Throw "Invalid organizational unit identifier '42'. Must be either a ``[TeamViewerPS.OrganizationalUnit``] or ``[UUID``]."
    }
}
