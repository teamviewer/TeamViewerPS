function ConvertTo-TeamViewerAuditEvent {
    param(
        [Parameter(ValueFromPipeline)]
        [PSObject]
        $InputObject
    )

    process {
        $Properties = @{
            Name         = $InputObject.EventName
            Type         = $InputObject.EventType
            Timestamp    = $InputObject.Timestamp | ConvertTo-DateTime
            Author       = $InputObject.Author
            AffectedItem = $InputObject.AffectedItem
            EventDetails = $InputObject.EventDetails
        }

        $Result = New-Object -TypeName PSObject -Property $Properties
        $Result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.AuditEvent')
        $Result | Add-Member -MemberType ScriptMethod -Name 'ToString' -Force -Value {
            "[$($this.Timestamp)] $($this.Name) ($($this.Type))"
        }

        Write-Output $Result
    }
}
