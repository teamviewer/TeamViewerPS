function ConvertTo-TeamViewerDevice {
    param(
        [Parameter(ValueFromPipeline)]
        [PSObject]
        $InputObject
    )
    process {
        $remoteControlId = $InputObject.remotecontrol_id | `
            Select-String -Pattern 'r(\d+)' | `
            ForEach-Object { $_.Matches.Groups[1].Value }
        $properties = @{
            Id                         = $InputObject.device_id
            TeamViewerId               = $remoteControlId
            GroupId                    = $InputObject.groupid
            Name                       = $InputObject.alias
            Description                = $InputObject.description
            OnlineState                = $InputObject.online_state
            IsAssignedToCurrentAccount = $InputObject.assigned_to
            SupportedFeatures          = $InputObject.supported_features
        }
        if ($InputObject.policy_id) {
            $properties['PolicyId'] = $InputObject.policy_id
        }
        if ($InputObject.last_seen) {
            $properties['LastSeenAt'] = [datetime]($InputObject.last_seen)
        }
        $result = New-Object -TypeName PSObject -Property $properties
        $result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.Device')
        $result | Add-Member -MemberType ScriptMethod -Name "ToString" -Force -Value {
            Write-Output "$($this.Name)"
        }
        Write-Output $result
    }
}
