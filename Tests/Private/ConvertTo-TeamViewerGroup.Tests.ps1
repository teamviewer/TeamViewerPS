BeforeAll {
    $Script:Module_RootPath = (Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..\..'))
    $Script:Module_PrivCmdletsPath = Join-Path -Path $Module_RootPath -ChildPath 'Cmdlets\Private'

    . (Join-Path -Path $Module_PrivCmdletsPath -ChildPath 'ConvertTo-TeamViewerGroupShare.ps1')
    . (Join-Path -Path $Module_PrivCmdletsPath -ChildPath 'ConvertTo-TeamViewerGroup.ps1')
}

Describe 'ConvertTo-TeamViewerGroup' {
    It 'Maps group and nested shared_with entries' {
        $inputObject = [pscustomobject]@{ id='g1'; name='Group'; permissions='all'; policy_id='p1'; shared_with=@([pscustomobject]@{ userid='u1'; name='N1'; permissions='read' }) }

        $result = ConvertTo-TeamViewerGroup -InputObject $inputObject

        $result.PSObject.TypeNames[0] | Should -Be 'TeamViewerPS.Group'
        $result.SharedWith.Count | Should -Be 1
        $result.SharedWith[0].PSObject.TypeNames[0] | Should -Be 'TeamViewerPS.GroupShare'
    }
}
