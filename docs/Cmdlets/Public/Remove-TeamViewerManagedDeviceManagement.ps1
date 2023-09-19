function Remove-TeamViewerManagedDeviceManagement {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerManagedDeviceId } )]
        [Alias('DeviceId')]
        [object]
        $Device
    )
    Process {
        $deviceId = $Device | Resolve-TeamViewerManagedDeviceId

        $resourceUri = "$(Get-TeamViewerApiUri)/managed/devices/$deviceId"

        if ($PSCmdlet.ShouldProcess($deviceId, 'Remove Management from a device (clears all managers and groups)')) {
            Invoke-TeamViewerRestMethod `
                -ApiToken $ApiToken `
                -Uri $resourceUri `
                -Method Delete `
                -WriteErrorTo $PSCmdlet | `
                Out-Null
        }
    }
}
