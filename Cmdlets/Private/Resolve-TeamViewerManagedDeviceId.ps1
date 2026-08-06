function Resolve-TeamViewerManagedDeviceId {
    param(
        [Parameter(ValueFromPipeline = $true, Mandatory = $true)]
        [object]
        $ManagedDevice
    )

    process {
        if ($ManagedDevice.PSObject.TypeNames -contains 'TeamViewerPS.ManagedDevice') {
            [guid]$ManagedDevice.Id
        }
        elseif ($ManagedDevice -is [string]) {
            [guid]$ManagedDevice
        }
        elseif ($ManagedDevice -is [guid]) {
            $ManagedDevice
        }
        else {
            throw "Invalid managed device identifier '$ManagedDevice'. Must be either a [TeamViewerPS.ManagedDevice], [guid] or [string]."
        }
    }
}
