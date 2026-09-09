function ConvertTo-TeamViewerConditionalAccessApprovalOption {
    param(
        [Parameter(ValueFromPipeline)]
        [object]
        $InputObject
    )

    process {
        $Properties = @{
            OptionId = [guid]$InputObject.optionId
            Name     = $InputObject.name
            Data     = $InputObject.data
        }

        $Result = New-Object -TypeName PSObject -Property $Properties
        $Result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.ConditionalAccessApprovalOption')

        Write-Output $Result
    }
}
