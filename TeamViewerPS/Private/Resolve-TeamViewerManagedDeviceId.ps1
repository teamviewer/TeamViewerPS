function Resolve-TeamViewerManagedDeviceId {
    param(
        [Parameter(ValueFromPipeline = $true, Mandatory = $true)]
        [object]
        $ManagedDevice
    )
    Process {
        if ($ManagedDevice.PSObject.TypeNames -contains 'TeamViewerPS.ManagedDevice') {
            return [guid]$ManagedDevice.Id
        }
        elseif ($ManagedDevice -is [string]) {
            return [guid]$ManagedDevice
        }
        elseif ($ManagedDevice -is [guid]) {
            return $ManagedDevice
        }
        else {
            throw "Invalid managed device identifier '$ManagedDevice'. Must be either a [TeamViewerPS.ManagedDevice], [guid] or [string]."
        }
    }
}
