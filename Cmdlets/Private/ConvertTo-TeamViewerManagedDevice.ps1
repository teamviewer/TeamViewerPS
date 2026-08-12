function ConvertTo-TeamViewerManagedDevice {
    param(
        [Parameter(ValueFromPipeline)]
        [PSObject]
        $InputObject
    )

    begin {
        $properties = @{
            Id           = [guid]$InputObject.id
            Name         = $InputObject.name
            TeamViewerId = $InputObject.TeamViewerId
            IsOnline     = $InputObject.isOnline
        }

        if ($InputObject.last_seen) {
            $properties['LastSeenAt'] = Get-Date -Date $InputObject.last_seen
        }

        if ($InputObject.teamviewerPolicyId) {
            $properties['PolicyId'] = [guid]$InputObject.teamviewerPolicyId
        }
    }

    process {
        $result = New-Object -TypeName PSObject -Property $properties
        $result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.ManagedDevice')

        $result
    }
}
