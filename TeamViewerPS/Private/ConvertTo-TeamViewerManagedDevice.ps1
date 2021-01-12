function ConvertTo-TeamViewerManagedDevice {
    param(
        [Parameter(ValueFromPipeline)]
        [PSObject]
        $InputObject
    )
    process {
        $properties = @{
            Id           = [guid]$InputObject.id
            Name         = $InputObject.name
            TeamViewerId = $InputObject.TeamViewerId
            IsOnline     = $InputObject.isOnline
        }

        if ($InputObject.pendingOperation) {
            $properties["PendingOperation"] = $InputObject.pendingOperation
        }

        $result = New-Object -TypeName PSObject -Property $properties
        $result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.ManagedDevice')
        Write-Output $result
    }
}
