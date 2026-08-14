BeforeAll {
    $Script:Module_RootPath = (Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..\..'))
    $Script:Module_PrivCmdletsPath = (Join-Path -Path $Module_RootPath -ChildPath 'Cmdlets\Private')

    . (Join-Path -Path $Module_PrivCmdletsPath -ChildPath 'ConvertTo-DateTime.ps1')
}

Describe 'ConvertTo-DateTime' {
    Context 'Valid input conversion' {
        It 'Converts valid date string: <InputString>' -TestCases @(
            @{ InputString = '2026-08-10'; Expected = [datetime]'2026-08-10' }
            @{ InputString = '2026-08-10T12:34:56Z'; Expected = [datetime]'2026-08-10T12:34:56Z' }
            @{ InputString = '2024-02-29'; Expected = [datetime]'2024-02-29' }
        ) {
            param(
                [string]$InputString,
                [datetime]$Expected
            )

            ConvertTo-DateTime -InputString $InputString | Should -Be $Expected
        }

        It 'Returns DateTime type for valid input' {
            $result = ConvertTo-DateTime -InputString '2026-08-10'

            $result | Should -BeOfType ([datetime])
        }

        It 'Accepts pipeline input from string values' {
            @('2026-08-10') | ConvertTo-DateTime | Should -Be ([datetime]'2026-08-10')
        }

        It 'Uses current culture for ambiguous date formats' {
            $ambiguousDate = '01/02/2026'
            $expected = [datetime]::Parse($ambiguousDate)

            ConvertTo-DateTime -InputString $ambiguousDate | Should -Be $expected
        }

        It 'Parses German date format under de-DE culture' {
            $originalCulture = [System.Threading.Thread]::CurrentThread.CurrentCulture
            $originalUICulture = [System.Threading.Thread]::CurrentThread.CurrentUICulture

            try {
                $germanCulture = [System.Globalization.CultureInfo]::GetCultureInfo('de-DE')
                [System.Threading.Thread]::CurrentThread.CurrentCulture = $germanCulture
                [System.Threading.Thread]::CurrentThread.CurrentUICulture = $germanCulture

                $germanDate = '13.02.2026 18:45:00'
                $expected = [datetime]::Parse($germanDate, $germanCulture)

                ConvertTo-DateTime -InputString $germanDate | Should -Be $expected
            }
            finally {
                [System.Threading.Thread]::CurrentThread.CurrentCulture = $originalCulture
                [System.Threading.Thread]::CurrentThread.CurrentUICulture = $originalUICulture
            }
        }
    }

    Context 'Invalid input handling' {
        It 'Returns null for invalid date input: <InputString>' -TestCases @(
            @{ InputString = 'not-a-date' }
            @{ InputString = '' }
            @{ InputString = '2026-13-01' }
            @{ InputString = '2026-02-30' }
            @{ InputString = $null }
            @{ InputString = '   ' }
        ) {
            param(
                [AllowNull()]
                [string]$InputString
            )

            ConvertTo-DateTime -InputString $InputString | Should -BeNull
        }

        It 'Does not throw for invalid date inputs' {
            {
                ConvertTo-DateTime -InputString 'invalid-date-value' | Out-Null
            } | Should -Not -Throw
        }
    }
}
