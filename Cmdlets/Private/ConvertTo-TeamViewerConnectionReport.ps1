function ConvertTo-TeamViewerConnectionReport {
    param(
        [Parameter(ValueFromPipeline)]
        [PSObject]
        $InputObject
    )
    process {
        $properties = @{
            Id                 = $InputObject.id
            UserId             = $InputObject.userid
            UserName           = $InputObject.username
            DeviceId           = $InputObject.deviceid
            DeviceName         = $InputObject.devicename
            GroupId            = $InputObject.groupid
            GroupName          = $InputObject.groupname
            SupportSessionType = [TeamViewerConnectionReportSessionType]$InputObject.support_session_type
            StartDate          = $InputObject.start_date | ConvertTo-DateTime
            EndDate            = $InputObject.end_date | ConvertTo-DateTime
            SessionCode        = $InputObject.session_code
            Fee                = $InputObject.fee
            BillingState       = $InputObject.billing_state
            Currency           = $InputObject.currency
            Notes              = $InputObject.notes
        }

        $result = New-Object -TypeName PSObject -Property $properties
        $result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.ConnectionReport')
        Write-Output $result
    }
}
