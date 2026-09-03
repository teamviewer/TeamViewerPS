function ConvertTo-TeamViewerAuditEvent {
    param(
        [Parameter(ValueFromPipeline)]
        [object]
        $InputObject
    )

    process {
        $Properties = @{
            Name         = $InputObject.EventName
            Type         = $InputObject.EventType
            Author       = $InputObject.Author
            AffectedItem = $InputObject.AffectedItem
            Details      = $InputObject.EventDetails
            CreatedAt    = $InputObject.Timestamp | ConvertTo-DateTime
        }

        $Result = New-Object -TypeName PSObject -Property $Properties
        $Result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.AuditEvent')

        Write-Output $Result
    }
}
