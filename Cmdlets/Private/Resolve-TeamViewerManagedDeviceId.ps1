function Resolve-TeamViewerManagedDeviceId {
    param(
        [Parameter(ValueFromPipeline = $true, Mandatory = $true)]
        [object]
        $ManagedDevice
    )

    process {
        if ($ManagedDevice.PSObject.TypeNames -contains 'TeamViewerPS.ManagedDevice') {
            Write-Output ([guid]$ManagedDevice.Id)
        }
        elseif ($ManagedDevice -is [string]) {
            Write-Output ([guid]$ManagedDevice)
        }
        elseif ($ManagedDevice -is [guid]) {
            Write-Output $ManagedDevice
        }
        else {
            throw "Invalid managed device identifier '$ManagedDevice'. Must be either a [TeamViewerPS.ManagedDevice], [guid] or [string]."
        }
    }
}
