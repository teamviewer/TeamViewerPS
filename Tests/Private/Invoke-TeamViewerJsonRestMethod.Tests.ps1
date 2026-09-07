BeforeAll {
    $Script:Module_RootPath = (Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..\..'))
    $Script:Module_PrivCmdletsPath = Join-Path -Path $Module_RootPath -ChildPath 'Cmdlets\Private'

    . (Join-Path -Path $Module_PrivCmdletsPath -ChildPath 'Invoke-TeamViewerRestMethod.ps1')
    . (Join-Path -Path $Module_PrivCmdletsPath -ChildPath 'Invoke-TeamViewerJsonRestMethod.ps1')

    function Get-TestSecureString {
        param(
            [Parameter(Mandatory = $true)]
            [string]
            $Value
        )

        $secure = New-Object -TypeName System.Security.SecureString
        foreach ($char in $Value.ToCharArray()) {
            $secure.AppendChar($char)
        }
        $secure.MakeReadOnly()

        $secure
    }
}

Describe 'Invoke-TeamViewerJsonRestMethod' {
    BeforeEach {
        $Script:CapturedArgs = @{}
        Mock Invoke-TeamViewerRestMethod {
            $Script:CapturedArgs.APIToken = $APIToken
            $Script:CapturedArgs.Uri = $Uri
            $Script:CapturedArgs.Method = $Method
            $Script:CapturedArgs.ContentType = $ContentType
            $Script:CapturedArgs.Body = $Body
            $Script:CapturedArgs.WriteErrorTo = $WriteErrorTo
            return [pscustomobject]@{ ok = $true }
        }

        $Script:TestToken = Get-TestSecureString -Value 'abc-token'
    }

    It 'Forwards the token, uri and method to Invoke-TeamViewerRestMethod' {
        Invoke-TeamViewerJsonRestMethod `
            -APIToken $TestToken `
            -Uri 'https://example.local/api/v1/test' `
            -Method Post `
            -Body '{"foo":"bar"}' | Out-Null

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Exactly -Scope It
        $CapturedArgs.APIToken | Should -Be $TestToken
        $CapturedArgs.Uri | Should -Be 'https://example.local/api/v1/test'
        $CapturedArgs.Method | Should -Be 'Post'
    }

    It 'Sets the JSON content type' {
        Invoke-TeamViewerJsonRestMethod `
            -APIToken $TestToken `
            -Uri 'https://example.local/api/v1/test' `
            -Method Post `
            -Body '{"foo":"bar"}' | Out-Null

        $CapturedArgs.ContentType | Should -Be 'application/json; charset=utf-8'
    }

    It 'Encodes the body as UTF-8 bytes' {
        $Payload = '{"name":"Christian J' + [char]0x00E4 + 'ckle"}'

        Invoke-TeamViewerJsonRestMethod `
            -APIToken $TestToken `
            -Uri 'https://example.local/api/v1/test' `
            -Method Post `
            -Body $Payload | Out-Null

        $CapturedArgs.Body | Should -BeOfType [byte]
        [System.Text.Encoding]::UTF8.GetString($CapturedArgs.Body) | Should -Be $Payload
    }

    It 'Passes the caller cmdlet through as the error target' {
        $FakeCmdlet = $PSCmdlet

        Invoke-TeamViewerJsonRestMethod `
            -APIToken $TestToken `
            -Uri 'https://example.local/api/v1/test' `
            -Method Delete `
            -Body '{}' `
            -CallerCmdlet $FakeCmdlet | Out-Null

        $CapturedArgs.WriteErrorTo | Should -Be $FakeCmdlet
    }

    It 'Returns the result of Invoke-TeamViewerRestMethod' {
        $Result = Invoke-TeamViewerJsonRestMethod `
            -APIToken $TestToken `
            -Uri 'https://example.local/api/v1/test' `
            -Method Post `
            -Body '{}'

        $Result.ok | Should -Be $true
    }
}
