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

        $Result = ConvertTo-ErrorRecord -InputObject $restError

        $Result | Should -BeOfType ([System.Management.Automation.ErrorRecord])
        $Result.ErrorDetails.Message | Should -Be 'Boom'
    }

    It 'Returns generic error record for plain string input' {
        $Result = ConvertTo-ErrorRecord -InputObject 'plain error'

        $Result | Should -BeOfType ([System.Management.Automation.ErrorRecord])
        $Result.Exception.Message | Should -Be 'plain error'
    }

    It 'Maps REST error category <Category> to <ExpectedCategory>' -TestCases @(
        @{ Category = 'invalid_request'; ExpectedCategory = 'InvalidArgument' }
        @{ Category = 'invalid_token'; ExpectedCategory = 'AuthenticationError' }
        @{ Category = 'internal_error'; ExpectedCategory = 'NotSpecified' }
        @{ Category = 'rate_limit_reached'; ExpectedCategory = 'LimitsExceeded' }
        @{ Category = 'token_expired'; ExpectedCategory = 'AuthenticationError' }
        @{ Category = 'wrong_credentials'; ExpectedCategory = 'AuthenticationError' }
        @{ Category = 'invalid_client'; ExpectedCategory = 'InvalidArgument' }
        @{ Category = 'not_found'; ExpectedCategory = 'ObjectNotFound' }
        @{ Category = 'too_many_retries'; ExpectedCategory = 'LimitsExceeded' }
        @{ Category = 'invalid_permission'; ExpectedCategory = 'PermissionDenied' }
        @{ Category = 'unknown'; ExpectedCategory = 'NotSpecified' }
    ) {
        $restError = [pscustomobject]@{ Message = 'Boom'; ErrorCategory = $Category }
        $restError.PSObject.TypeNames.Insert(0, 'TeamViewerPS.RestError')
        $restError | Add-Member -MemberType ScriptMethod -Name 'ToString' -Force -Value { $this.Message }

        $Result = ConvertTo-ErrorRecord -InputObject $restError

        $Result.CategoryInfo.Category | Should -Be $ExpectedCategory
    }
}
