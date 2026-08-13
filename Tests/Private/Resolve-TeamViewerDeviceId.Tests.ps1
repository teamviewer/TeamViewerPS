BeforeAll {
    $Script:Module_RootPath = (Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..\..'))
    $Script:Module_PrivCmdletsPath = Join-Path -Path $Module_RootPath -ChildPath 'Cmdlets\Private'

    . (Join-Path -Path $Module_PrivCmdletsPath -ChildPath 'Resolve-TeamViewerDeviceId.ps1')
}

Describe 'Resolve-TeamViewerDeviceId' {
    It 'Returns Id from TeamViewerPS.Device object' {
        $device = [pscustomobject]@{ Id = 'd123456' }
        $device.PSObject.TypeNames.Insert(0, 'TeamViewerPS.Device')

        Resolve-TeamViewerDeviceId -Device $device | Should -Be 'd123456'
    }

    It 'Returns valid device id string unchanged' {
        Resolve-TeamViewerDeviceId -Device 'd123456' | Should -Be 'd123456'
    }

    It 'Throws for invalid device id string' {
        { Resolve-TeamViewerDeviceId -Device '123456' } | Should -Throw
    }
}
