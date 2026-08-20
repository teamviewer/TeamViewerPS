function ConvertTo-TeamViewerConnectionReport {
    param(
        [Parameter(ValueFromPipeline)]
        [object]
        $InputObject
    )

    process {
        $Properties = @{
            Id               = $InputObject.id
            User_Id          = $InputObject.userid
            User_Name        = $InputObject.username
            Device_Id        = $InputObject.deviceid
            Device_Name      = $InputObject.devicename
            Group_Id         = $InputObject.groupid
            Group_Name       = $InputObject.groupname
            Session_Type     = [TeamViewerConnectionReportSessionType]$InputObject.support_session_type
            Datetime_Start   = $InputObject.start_date | ConvertTo-DateTime
            Datetime_End     = $InputObject.end_date | ConvertTo-DateTime
            SessionCode      = $InputObject.session_code
            Billing_Fee      = $InputObject.fee
            Billing_State    = $InputObject.billing_state
            Billing_Currency = $InputObject.currency
            Notes            = $InputObject.notes
        }

        $Result = New-Object -TypeName PSObject -Property $Properties
        $Result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.ConnectionReport')

        Write-Output $Result
    }
}
