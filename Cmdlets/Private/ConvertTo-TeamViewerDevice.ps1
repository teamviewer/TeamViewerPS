function ConvertTo-TeamViewerDevice {
    param(
        [Parameter(ValueFromPipeline)]
        [object]
        $InputObject
    )

    process {
        $RemoteControlId = $InputObject.remotecontrol_id | Select-String -Pattern 'r(\d+)' | ForEach-Object { $_.Matches.Groups[1].Value }
        $Properties = @{
            Id                         = $InputObject.device_id
            TeamViewerId               = $RemoteControlId
            GroupId                    = $InputObject.groupid
            Name                       = $InputObject.alias
            Description                = $InputObject.description
            OnlineState                = $InputObject.online_state
            IsAssignedToCurrentAccount = $InputObject.assigned_to
            SupportedFeatures          = $InputObject.supported_features
        }

        if ($InputObject.policy_id) {
            $Properties['PolicyId'] = $InputObject.policy_id
        }

        if ($InputObject.last_seen) {
            $Properties['LastSeenAt'] = [datetime]($InputObject.last_seen)
        }

        $Result = New-Object -TypeName PSObject -Property $Properties
        $Result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.Device')
        $Result | Add-Member -MemberType ScriptMethod -Name 'ToString' -Force -Value {
            "$($this.Name)"
        }

        Write-Output $Result
    }
}
