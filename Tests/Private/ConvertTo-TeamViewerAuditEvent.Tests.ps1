BeforeAll {
    $Script:Module_RootPath = (Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..\..'))
    $Script:Module_PrivCmdletsPath = Join-Path -Path $Module_RootPath -ChildPath 'Cmdlets\Private'

    . (Join-Path -Path $Module_PrivCmdletsPath -ChildPath 'ConvertTo-DateTime.ps1')
    . (Join-Path -Path $Module_PrivCmdletsPath -ChildPath 'ConvertTo-TeamViewerAuditEvent.ps1')
}

Describe 'ConvertTo-TeamViewerAuditEvent' {
    It 'Maps audit event and converts event date' {
        $inputObject = [pscustomobject]@{ EventName='login'; EventType='auth'; Timestamp='2026-01-01'; Author='User'; AffectedItem='item'; EventDetails='details' }

        $result = ConvertTo-TeamViewerAuditEvent -InputObject $inputObject

        $result.PSObject.TypeNames[0] | Should -Be 'TeamViewerPS.AuditEvent'
        $result.Timestamp | Should -BeOfType ([datetime])
    }
}
