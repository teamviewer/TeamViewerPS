BeforeAll {
    $Script:Module_RootPath = (Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..\..'))
    $Script:Module_PrivCmdletsPath = Join-Path -Path $Module_RootPath -ChildPath 'Cmdlets\Private'

    . (Join-Path -Path $Module_PrivCmdletsPath -ChildPath 'ConvertTo-ErrorRecord.ps1')
}

Describe 'ConvertTo-ErrorRecord' {
    It 'Converts TeamViewerPS.RestError object to ErrorRecord' {
        $restError = [pscustomobject]@{ Message = 'Boom'; ErrorCategory = 'invalid'; ErrorCode = 42; ErrorSignature = 'sig' }
        $restError.PSObject.TypeNames.Insert(0, 'TeamViewerPS.RestError')
        $restError | Add-Member -MemberType ScriptMethod -Name 'ToString' -Force -Value {
            $this.Message
        }

        $result = ConvertTo-ErrorRecord -InputObject $restError

        $result | Should -BeOfType ([System.Management.Automation.ErrorRecord])
        $result.ErrorDetails.Message | Should -Be 'Boom'
    }

    It 'Returns generic error record for plain string input' {
        $result = ConvertTo-ErrorRecord -InputObject 'plain error'

        $result | Should -BeOfType ([System.Management.Automation.ErrorRecord])
        $result.Exception.Message | Should -Be 'plain error'
    }
}
