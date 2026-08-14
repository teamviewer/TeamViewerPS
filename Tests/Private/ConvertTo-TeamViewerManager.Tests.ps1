BeforeAll {
    $Script:Module_RootPath = (Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..\..'))
    $Script:Module_PrivCmdletsPath = Join-Path -Path $Module_RootPath -ChildPath 'Cmdlets\Private'

    . (Join-Path -Path $Module_PrivCmdletsPath -ChildPath 'ConvertTo-TeamViewerManager.ps1')
}

Describe 'ConvertTo-TeamViewerManager' {
    It 'Sets GroupId when using GroupManager parameter set' {
        $groupId = [guid]::NewGuid()
        $inputObject = [pscustomobject]@{ id = [guid]::NewGuid().ToString(); type='account'; name='mgr'; permissions='all'; accountId='u123' }

        $result = ConvertTo-TeamViewerManager -InputObject $inputObject -GroupId $groupId

        $result.PSObject.TypeNames[0] | Should -Be 'TeamViewerPS.Manager'
        $result.GroupId | Should -Be $groupId
    }

    It 'Sets DeviceId when using DeviceManager parameter set' {
        $deviceId = [guid]::NewGuid()
        $inputObject = [pscustomobject]@{ id = [guid]::NewGuid().ToString(); type='company'; name='mgr'; permissions='all'; companyId='c123' }

        $result = ConvertTo-TeamViewerManager -InputObject $inputObject -DeviceId $deviceId

        $result.PSObject.TypeNames[0] | Should -Be 'TeamViewerPS.Manager'
        $result.DeviceId | Should -Be $deviceId
    }
}
