BeforeAll {
    $Script:Module_RootPath = (Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..\..'))
    $Script:Module_PrivCmdletsPath = Join-Path -Path $Module_RootPath -ChildPath 'Cmdlets\Private'

    . (Join-Path -Path $Module_PrivCmdletsPath -ChildPath 'Resolve-TeamViewerManagedDeviceId.ps1')
}

Describe 'Resolve-TeamViewerManagedDeviceId' {
    It 'Returns guid from TeamViewerPS.ManagedDevice object' {
        $Id = [guid]::NewGuid()
        $device = [pscustomobject]@{ Id = $Id }
        $device.PSObject.TypeNames.Insert(0, 'TeamViewerPS.ManagedDevice')

        Resolve-TeamViewerManagedDeviceId -ManagedDevice $device | Should -Be $id
    }

    It 'Converts guid string to guid' {
        $Id = [guid]::NewGuid()

        Resolve-TeamViewerManagedDeviceId -ManagedDevice $id.ToString() | Should -Be $id
    }

    It 'Returns guid input unchanged' {
        $Id = [guid]::NewGuid()

        Resolve-TeamViewerManagedDeviceId -ManagedDevice $Id | Should -Be $id
    }
}
