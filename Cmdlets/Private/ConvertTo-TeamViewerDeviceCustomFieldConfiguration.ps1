function ConvertTo-TeamViewerDeviceCustomFieldConfiguration {
    param(
        [Parameter(ValueFromPipeline)]
        [object]
        $InputObject
    )

    process {
        $Properties = @{
            Id          = $InputObject.fieldKeyId
            Name        = $InputObject.fieldKey
            Type        = $InputObject.fieldType
            Description = $InputObject.description
            CreatedAt   = $InputObject.createdAt | ConvertTo-DateTime
            UpdatedAt   = $InputObject.updatedAt | ConvertTo-DateTime
        }

        $Result = New-Object -TypeName PSObject -Property $Properties
        $Result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.DeviceCustomFieldConfiguration')

        Write-Output $Result
    }
}
