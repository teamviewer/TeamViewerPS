function ConvertTo-TeamViewerDevice {
    param(
        [Parameter(ValueFromPipeline)]
        [object]
        $InputObject
    )

    process {
        $RemoteControlId = $InputObject.remotecontrol_id | Select-String -Pattern 'r(\d+)' | ForEach-Object { $_.Matches.Groups[1].Value }

        $Properties = @{
            Id                 = $InputObject.device_id
            TeamViewerId       = $RemoteControlId
            Name               = $InputObject.alias
            Description        = $InputObject.description
            OnlineState        = $InputObject.online_state
            Group_Id           = $InputObject.groupid
            Assigned_To        = $InputObject.assigned_to
            Features_Supported = $InputObject.supported_features
        }

        if ($InputObject.policy_id) {
            $Properties['Policy_Id'] = $InputObject.policy_id
        }

        if ($InputObject.last_seen) {
            $Properties['LastSeen_At'] = [datetime]($InputObject.last_seen | ConvertTo-DateTime)
        }

        $Result = New-Object -TypeName PSObject -Property $Properties
        $Result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.Device')

        Write-Output $Result
    }
}
