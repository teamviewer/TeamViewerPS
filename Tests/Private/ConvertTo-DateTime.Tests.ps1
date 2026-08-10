BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Private\ConvertTo-DateTime.ps1"
}

Describe 'ConvertTo-DateTime' {
    It 'Should convert a valid date string' {
        ConvertTo-DateTime -InputString '2026-08-10' | Should -Be ([datetime]'2026-08-10')
    }

    It 'Should return null for an invalid date string' {
        ConvertTo-DateTime -InputString 'not-a-date' | Should -BeNull
    }
}
