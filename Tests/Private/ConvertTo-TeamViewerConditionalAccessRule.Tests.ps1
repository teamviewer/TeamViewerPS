BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\TeamViewerPS.Types.ps1"
    . "$PSScriptRoot\..\..\Cmdlets\Private\ConvertTo-DateTime.ps1"
    . "$PSScriptRoot\..\..\Cmdlets\Private\ConvertTo-TeamViewerConditionalAccessRule.ps1"
}

Describe 'ConvertTo-TeamViewerConditionalAccessRule' {
    It 'Maps a rule and its expiration' {
        $InputObject = [pscustomobject]@{
            ruleId = 'rule-1'; sourceId = 'source-1'; sourceType = 0; targetId = 'target-1'; targetType = 3; state = 0
            featuresOptionId = 'b5b8c706-710d-43c5-b775-dc86347d9e56'
            expirations = @([pscustomobject]@{ StartsOn = '2026-01-01T00:00:00Z'; ExpiresOn = '2026-01-02T00:00:00Z'; Description = 'Test'; TimezoneOffset = 0; Timezone = 'UTC' })
            comment = 'Unit test rule'
        }

        $Result = $InputObject | ConvertTo-TeamViewerConditionalAccessRule

        $Result.PSObject.TypeNames | Should -Contain 'TeamViewerPS.ConditionalAccessRule'
        $Result.SourceType | Should -Be ([ConditionalAccessSourceTargetType]::AccountId)
        $Result.TargetType | Should -Be ([ConditionalAccessSourceTargetType]::DirectoryGroupId)
        $Result.FeaturesOptionId | Should -Be ([guid]'b5b8c706-710d-43c5-b775-dc86347d9e56')
        $Result.Expirations[0].StartsOn | Should -BeOfType ([datetime])
    }
}
