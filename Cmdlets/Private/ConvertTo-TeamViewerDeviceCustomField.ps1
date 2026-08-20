function ConvertTo-TeamViewerDeviceCustomField {
    param(
        [Parameter(ValueFromPipeline)]
        [object]
        $InputObject
    )

    process {
        $Properties = @{
            Id    = $InputObject.fieldKeyId
            Value = $InputObject.value
        }

        $Result = New-Object -TypeName PSObject -Property $Properties
        $Result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.DeviceCustomField')

        Write-Output $Result
    }
}
