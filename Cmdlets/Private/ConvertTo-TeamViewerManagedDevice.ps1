function ConvertTo-TeamViewerManagedDevice {
    param(
        [Parameter(ValueFromPipeline)]
        [object]
        $InputObject
    )

    process {
        $Properties = @{
            Id           = [guid]$InputObject.id
            TeamViewerId = $InputObject.TeamViewerId
            Name         = $InputObject.name
            IsOnline     = $InputObject.isOnline
        }

        if ($InputObject.last_seen) {
            $Properties['LastSeen_At'] = Get-Date -Date $InputObject.last_seen
        }

        if ($InputObject.teamviewerPolicyId) {
            $Properties['Policy_Id'] = [guid]$InputObject.teamviewerPolicyId
        }

        $Result = New-Object -TypeName PSObject -Property $Properties
        $Result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.ManagedDevice')

        Write-Output $Result
    }
}
