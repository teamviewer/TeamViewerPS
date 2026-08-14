BeforeAll {
    $Script:Module_RootPath = (Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..\..'))
    $Script:Module_PrivCmdletsPath = Join-Path -Path $Module_RootPath -ChildPath 'Cmdlets\Private'

    . (Join-Path -Path $Module_RootPath -ChildPath 'Cmdlets\TeamViewerPS.Types.ps1')
    . (Join-Path -Path $Module_PrivCmdletsPath -ChildPath 'ConvertTo-DateTime.ps1')
    . (Join-Path -Path $Module_PrivCmdletsPath -ChildPath 'ConvertTo-TeamViewerConnectionReport.ps1')
}

Describe 'ConvertTo-TeamViewerConnectionReport' {
    It 'Maps report properties and converts start/end dates' {
        $inputObject = [pscustomobject]@{ id='1'; userid='u1'; username='User'; deviceid='d1'; devicename='Device'; groupid='g1'; groupname='Group'; support_session_type='1'; start_date='2026-01-01'; end_date='2026-01-02'; session_code='s1'; fee='10'; billing_state='b'; currency='EUR'; notes='n' }

        $result = ConvertTo-TeamViewerConnectionReport -InputObject $inputObject

        $result.PSObject.TypeNames[0] | Should -Be 'TeamViewerPS.ConnectionReport'
        $result.StartDate | Should -BeOfType ([datetime])
        $result.EndDate | Should -BeOfType ([datetime])
    }
}
