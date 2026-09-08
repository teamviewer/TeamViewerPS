function ConvertTo-TeamViewerConditionalAccessRule {
    param(
        [Parameter(ValueFromPipeline)]
        [object]
        $InputObject
    )

    process {
        $Expirations = @(
            $InputObject.expirations | ForEach-Object {
                [pscustomobject]@{
                    StartsOn       = $_.StartsOn | ConvertTo-DateTime
                    ExpiresOn      = $_.ExpiresOn | ConvertTo-DateTime
                    Description    = $_.Description
                    Timezone       = $_.Timezone
                    TimezoneOffset = $_.TimezoneOffset
                }
            }
        )

        $Properties = @{
            Id               = $InputObject.ruleId
            SourceId         = $InputObject.sourceId
            SourceType       = [ConditionalAccessSourceTargetType]$InputObject.sourceType
            TargetId         = $InputObject.targetId
            TargetType       = [ConditionalAccessSourceTargetType]$InputObject.targetType
            State            = [ConditionalAccessRuleState]$InputObject.state
            OptionSetId      = if ($InputObject.optionSetId) {
                [guid]$InputObject.optionSetId 
            }
            FeaturesOptionId = if ($InputObject.featuresOptionId) {
                [guid]$InputObject.featuresOptionId 
            }
            TimeOptionId     = if ($InputObject.timeOptionId) {
                [guid]$InputObject.timeOptionId 
            }
            LocationOptionId = if ($InputObject.locationOptionId) {
                [guid]$InputObject.locationOptionId 
            }
            ApprovalOptionId = if ($InputObject.approvalOptionId) {
                [guid]$InputObject.approvalOptionId 
            }
            Expirations      = $Expirations
            Comment          = $InputObject.comment
        }

        $Result = New-Object -TypeName PSObject -Property $Properties
        $Result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.ConditionalAccessRule')

        Write-Output $Result
    }
}
