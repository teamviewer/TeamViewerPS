function ConvertTo-TeamViewerDeviceCustomField {
    param(
        [Parameter(ValueFromPipeline)]
        [PSObject]
        $InputObject
    )

    process {
        $Properties = @{
            FieldKeyId = $InputObject.fieldKeyId
            Value      = $InputObject.value
        }

        $Result = New-Object -TypeName PSObject -Property $Properties
        $Result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.DeviceCustomField')

        $Result | Add-Member -MemberType ScriptMethod -Name 'ToString' -Force -Value {
            '{0}' -f $this.Value
        }

        Write-Output $Result
    }
}
