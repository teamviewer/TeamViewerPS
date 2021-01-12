function Resolve-TeamViewerDeviceId {
    param(
        [Parameter(ValueFromPipeline = $true, Mandatory = $true)]
        [object]
        $Device
    )
    Process {
        if ($Device.PSObject.TypeNames -contains 'TeamViewerPS.Device') {
            return $Device.Id
        }
        elseif ($Device -is [string]) {
            if ($Device -notmatch 'd[0-9]+') {
                throw "Invalid device identifier '$Device'. String must be a device ID in the form 'd123456789'."
            }
            return $Device
        }
        else {
            throw "Invalid device identifier '$Device'. Must be either a [TeamViewerPS.Device] or [string]."
        }
    }
}
