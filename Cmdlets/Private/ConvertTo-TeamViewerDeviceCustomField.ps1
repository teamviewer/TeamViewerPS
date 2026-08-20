function ConvertTo-TeamViewerDeviceCustomField {
    param(
        [Parameter(ValueFromPipeline)]
        [object]
        $InputObject
    )

    process {
        $Properties = @{
            Id        = $InputObject.id
            Field_Id  = $InputObject.fieldKeyId
            Value     = $InputObject.value
            CreatedAt = $InputObject.createdAt | ConvertTo-DateTime
            UpdatedAt = $InputObject.updatedAt | ConvertTo-DateTime
        }

        $Result = New-Object -TypeName PSObject -Property $Properties
        $Result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.DeviceCustomField')

        Write-Output $Result
    }
}
