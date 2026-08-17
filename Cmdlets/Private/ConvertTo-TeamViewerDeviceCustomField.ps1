function ConvertTo-TeamViewerDeviceCustomField {
    param(
        [Parameter(ValueFromPipeline)]
        [PSObject]
        $InputObject
    )

    process {
        $properties = @{
            Id          = $InputObject.fieldKeyId
            FieldKey    = $InputObject.fieldKey
            FieldType   = $InputObject.fieldType
            Description = $InputObject.description
            CreatedAt   = $InputObject.createdAt | ConvertTo-DateTime
            UpdatedAt   = $InputObject.updatedAt | ConvertTo-DateTime
        }

        $result = New-Object -TypeName PSObject -Property $properties
        $result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.DeviceCustomField')

        $result | Add-Member -MemberType ScriptMethod -Name 'ToString' -Force -Value {
            '{0} ({1})' -f $this.FieldKey, $this.Id
        }

        Write-Output $result
    }
}
