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
            OptionSetId      = $null
            FeaturesOptionId = $null
            TimeOptionId     = $null
            LocationOptionId = $null
            ApprovalOptionId = $null
            Expirations      = $Expirations
            Comment          = $InputObject.comment
        }

        if ($InputObject.optionSetId) {
            $Properties.OptionSetId = [guid]$InputObject.optionSetId
        }

        if ($InputObject.featuresOptionId) {
            $Properties.FeaturesOptionId = [guid]$InputObject.featuresOptionId
        }

        if ($InputObject.timeOptionId) {
            $Properties.TimeOptionId = [guid]$InputObject.timeOptionId
        }

        if ($InputObject.locationOptionId) {
            $Properties.LocationOptionId = [guid]$InputObject.locationOptionId
        }

        if ($InputObject.approvalOptionId) {
            $Properties.ApprovalOptionId = [guid]$InputObject.approvalOptionId
        }

        $Result = New-Object -TypeName PSObject -Property $Properties
        $Result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.ConditionalAccessRule')

        Write-Output $Result
    }
}
