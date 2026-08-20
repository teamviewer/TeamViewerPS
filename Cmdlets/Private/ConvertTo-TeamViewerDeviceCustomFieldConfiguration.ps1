function ConvertTo-TeamViewerDeviceCustomFieldConfiguration {
    param(
        [Parameter(ValueFromPipeline)]
        [PSObject]
        $InputObject
    )

    process {
        $Properties = @{
            Id          = $InputObject.fieldKeyId
            FieldKey    = $InputObject.fieldKey
            FieldType   = $InputObject.fieldType
            Description = $InputObject.description
            CreatedAt   = $InputObject.createdAt | ConvertTo-DateTime
            UpdatedAt   = $InputObject.updatedAt | ConvertTo-DateTime
        }

        $Result = New-Object -TypeName PSObject -Property $Properties
        $Result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.DeviceCustomFieldConfiguration')

        $Result | Add-Member -MemberType ScriptMethod -Name 'ToString' -Force -Value {
            '{0} ({1})' -f $this.FieldKey, $this.Id
        }

        Write-Output $Result
    }
}
