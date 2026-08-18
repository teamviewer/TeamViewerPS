BeforeAll {
    $Script:Module_RootPath = (Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..\..'))
    $Script:Module_PrivCmdletsPath = Join-Path -Path $Module_RootPath -ChildPath 'Cmdlets\Private'

    . (Join-Path -Path $Module_PrivCmdletsPath -ChildPath 'ConvertTo-TeamViewerManager.ps1')
}

Describe 'ConvertTo-TeamViewerManager' {
    It 'Sets GroupId when using GroupManager parameter set' {
        $GroupId = [guid]::NewGuid()
        $InputObject = [pscustomobject]@{ id = [guid]::NewGuid().ToString(); type = 'account'; name = 'mgr'; permissions = 'all'; accountId = 'u123' }

        $Result = ConvertTo-TeamViewerManager -InputObject $InputObject -GroupId $GroupId

        $Result.PSObject.TypeNames[0] | Should -Be 'TeamViewerPS.Manager'
        $Result.GroupId | Should -Be $GroupId
    }

    It 'Sets DeviceId when using DeviceManager parameter set' {
        $DeviceId = [guid]::NewGuid()
        $InputObject = [pscustomobject]@{ id = [guid]::NewGuid().ToString(); type = 'company'; name = 'mgr'; permissions = 'all'; companyId = 'c123' }

        $Result = ConvertTo-TeamViewerManager -InputObject $InputObject -DeviceId $DeviceId

        $Result.PSObject.TypeNames[0] | Should -Be 'TeamViewerPS.Manager'
        $Result.DeviceId | Should -Be $DeviceId
    }
}
