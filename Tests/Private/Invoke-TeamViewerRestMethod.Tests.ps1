BeforeAll {
    $Script:Module_RootPath = (Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..\..'))
    $Script:Module_PrivCmdletsPath = Join-Path -Path $Module_RootPath -ChildPath 'Cmdlets\Private'

    . (Join-Path -Path $Module_PrivCmdletsPath -ChildPath 'ConvertTo-TeamViewerRestError.ps1')
    . (Join-Path -Path $Module_PrivCmdletsPath -ChildPath 'ConvertTo-ErrorRecord.ps1')
    . (Join-Path -Path $Module_PrivCmdletsPath -ChildPath 'Invoke-TeamViewerRestMethod.ps1')

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

Describe 'Invoke-TeamViewerRestMethod' {
    BeforeEach {
        $global:TeamViewerProxyUriSet = $null
        $global:TeamViewerProxyUriRemoved = $null
        [Environment]::SetEnvironmentVariable('TeamViewerProxyUri', $null)
    }

    It 'Adds bearer authorization header and returns parsed JSON content' {
        Mock -CommandName Invoke-WebRequest -MockWith {
            [pscustomobject]@{ Content = '{"ok":true,"value":1}' }
        }

        $token = Get-TestSecureString -Value 'abc-token'
        $Result = Invoke-TeamViewerRestMethod -ApiToken $token -Uri 'https://example.local/api/v1/test' -Method Get

        Should -Invoke Invoke-WebRequest -Times 1 -Exactly -ParameterFilter { $Headers.Authorization -eq 'Bearer abc-token' }
        $Result.ok | Should -Be $true
        $Result.value | Should -Be 1
    }

    It 'Adds a distinguishing User-Agent header when none is provided' {
        Mock -CommandName Invoke-WebRequest -MockWith {
            [pscustomobject]@{ Content = '{}' }
        }

        $token = Get-TestSecureString -Value 'abc-token'
        $null = Invoke-TeamViewerRestMethod -ApiToken $token -Uri 'https://example.local/api/v1/test' -Method Get

        Should -Invoke Invoke-WebRequest -Times 1 -Exactly -ParameterFilter { $Headers.'User-Agent' -like 'TeamViewerPS/*' }
    }

    It 'Uses explicit global proxy when configured' {
        $global:TeamViewerProxyUriSet = 'http://proxy.local:8080'

        Mock -CommandName Invoke-WebRequest -MockWith { [pscustomobject]@{ Content = '{}' } } -ParameterFilter { $Proxy -eq 'http://proxy.local:8080' }

        $token = Get-TestSecureString -Value 'abc-token'
        $null = Invoke-TeamViewerRestMethod -ApiToken $token -Uri 'https://example.local/api/v1/test' -Method Get

        Should -Invoke Invoke-WebRequest -Times 1 -Exactly
    }

    It 'Throws converted TeamViewerPS.RestError when request fails and WriteErrorTo is not provided' {
        Mock -CommandName Invoke-WebRequest -MockWith {
            throw ([System.Exception]::new('http fail'))
        }

        $token = Get-TestSecureString -Value 'abc-token'

        { Invoke-TeamViewerRestMethod -ApiToken $token -Uri 'https://example.local/api/v1/test' -Method Get } | Should -Throw
    }

    It 'Writes converted error to provided PSCmdlet when request fails and WriteErrorTo is provided' {
        function Invoke-TestInvokeTeamViewerRestMethod {
            [CmdletBinding()]
            param()

            process {
                $token = Get-TestSecureString -Value 'abc-token'
                $null = Invoke-TeamViewerRestMethod -ApiToken $token -Uri 'https://example.local/api/v1/test' -Method Get -WriteErrorTo $PSCmdlet
            }
        }

        Mock -CommandName Invoke-WebRequest -MockWith {
            throw ([System.Exception]::new('http fail'))
        }

        {
            Invoke-TestInvokeTeamViewerRestMethod -ErrorAction SilentlyContinue
        } | Should -Not -Throw
    }
}
