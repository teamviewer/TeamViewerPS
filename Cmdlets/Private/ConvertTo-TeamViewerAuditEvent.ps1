function ConvertTo-TeamViewerAuditEvent {
    param(
        [Parameter(ValueFromPipeline)]
        [PSObject]
        $InputObject
    )

    process {
        $properties = @{
            Name         = $InputObject.EventName
            Type         = $InputObject.EventType
            Timestamp    = $InputObject.Timestamp | ConvertTo-DateTime
            Author       = $InputObject.Author
            AffectedItem = $InputObject.AffectedItem
            EventDetails = $InputObject.EventDetails
        }

        $result = New-Object -TypeName PSObject -Property $properties
        $result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.AuditEvent')
        $result | Add-Member -MemberType ScriptMethod -Name 'ToString' -Force -Value {
            "[$($this.Timestamp)] $($this.Name) ($($this.Type))"
        }

        $result
    }
}
