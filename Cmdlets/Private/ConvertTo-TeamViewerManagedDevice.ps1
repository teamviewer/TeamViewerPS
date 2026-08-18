function ConvertTo-TeamViewerManagedDevice {
    param(
        [Parameter(ValueFromPipeline)]
        [PSObject]
        $InputObject
    )

    process {
        $Properties = @{
            Id           = [guid]$InputObject.id
            Name         = $InputObject.name
            TeamViewerId = $InputObject.TeamViewerId
            IsOnline     = $InputObject.isOnline
        }

        if ($InputObject.last_seen) {
            $Properties['LastSeenAt'] = Get-Date -Date $InputObject.last_seen
        }

        if ($InputObject.teamviewerPolicyId) {
            $Properties['PolicyId'] = [guid]$InputObject.teamviewerPolicyId
        }

        $Result = New-Object -TypeName PSObject -Property $Properties
        $Result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.ManagedDevice')

        Write-Output $Result
    }
}
