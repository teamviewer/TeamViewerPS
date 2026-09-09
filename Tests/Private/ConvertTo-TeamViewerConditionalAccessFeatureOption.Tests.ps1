BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\TeamViewerPS.Types.ps1"
    . "$PSScriptRoot\..\..\Cmdlets\Private\ConvertTo-TeamViewerConditionalAccessFeatureOption.ps1"
}

Describe 'ConvertTo-TeamViewerConditionalAccessFeatureOption' {
    BeforeAll {
        $InputObject = [pscustomobject]@{
            optionId = 'b5b8c706-710d-43c5-b775-dc86347d9e56'
            name     = 'Unit Test Feature Option'
            data     = [pscustomobject]@{
                connectAndViewScreen = 0
                controlComputer      = 1
                fileTransfer         = 2
            }
        }
        $null = $InputObject
    }

    It 'Should return a ConditionalAccessFeatureOption object' {
        $Result = $InputObject | ConvertTo-TeamViewerConditionalAccessFeatureOption

        $Result.PSObject.TypeNames | Should -Contain 'TeamViewerPS.ConditionalAccessFeatureOption'
    }

    It 'Should map the option properties' {
        $Result = $InputObject | ConvertTo-TeamViewerConditionalAccessFeatureOption

        $Result.OptionId | Should -Be ([guid]'b5b8c706-710d-43c5-b775-dc86347d9e56')
        $Result.Name | Should -Be 'Unit Test Feature Option'
        $Result.Data.connectAndViewScreen | Should -Be ([ConditionalAccessFeatureAccessLevel]::Allow)
        $Result.Data.controlComputer | Should -Be ([ConditionalAccessFeatureAccessLevel]::AfterConfirmation)
        $Result.Data.fileTransfer | Should -Be ([ConditionalAccessFeatureAccessLevel]::Denied)
    }
}
