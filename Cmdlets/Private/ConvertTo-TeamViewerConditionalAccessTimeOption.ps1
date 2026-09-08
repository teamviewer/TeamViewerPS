function ConvertTo-TeamViewerConditionalAccessTimeOption {
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
        $Result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.ConditionalAccessTimeOption')

        Write-Output $Result
    }
}
