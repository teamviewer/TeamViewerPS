BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Private\ConvertTo-TeamViewerConditionalAccessTimeOption.ps1"
}

Describe 'ConvertTo-TeamViewerConditionalAccessTimeOption' {
    It 'Maps a time option' {
        $InputObject = [pscustomobject]@{
            optionId = 'b5b8c706-710d-43c5-b775-dc86347d9e56'
            name     = 'Unit Test Time Option'
            data     = [pscustomobject]@{ timeZone = 'UTC'; mondayIntervals = @() }
        }

        $Result = $InputObject | ConvertTo-TeamViewerConditionalAccessTimeOption

        $Result.PSObject.TypeNames | Should -Contain 'TeamViewerPS.ConditionalAccessTimeOption'
        $Result.OptionId | Should -Be ([guid]'b5b8c706-710d-43c5-b775-dc86347d9e56')
        $Result.Data.timeZone | Should -Be 'UTC'
    }
}
