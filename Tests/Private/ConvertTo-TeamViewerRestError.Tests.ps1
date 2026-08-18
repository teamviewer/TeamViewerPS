BeforeAll {
    $Script:Module_RootPath = (Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..\..'))
    $Script:Module_PrivCmdletsPath = Join-Path -Path $Module_RootPath -ChildPath 'Cmdlets\Private'

    . (Join-Path -Path $Module_PrivCmdletsPath -ChildPath 'ConvertTo-TeamViewerRestError.ps1')
}

Describe 'ConvertTo-TeamViewerRestError' {
    It 'Parses JSON error payload into TeamViewerPS.RestError object' {
        $json = '{"error_description":"Bad Request","error":"invalid_request","error_code":400,"error_signature":"sig"}'

        $Result = ConvertTo-TeamViewerRestError -InputError $json

        $Result.PSObject.TypeNames[0] | Should -Be 'TeamViewerPS.RestError'
        $Result.Message | Should -Be 'Bad Request'
        $Result.ErrorCode | Should -Be 400
    }

    It 'Returns input unchanged when payload is not JSON' {
        ConvertTo-TeamViewerRestError -InputError 'raw text' | Should -Be 'raw text'
    }
}
