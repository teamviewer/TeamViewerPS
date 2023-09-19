function Remove-TeamViewerManagedDevice {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerManagedDeviceId } )]
        [Alias("DeviceId")]
        [object]
        $Device,

        [Parameter(Mandatory = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerManagedGroupId } )]
        [Alias("GroupId")]
        [object]
        $Group
    )
    Process {
        $deviceId = $Device | Resolve-TeamViewerManagedDeviceId
        $groupId = $Group | Resolve-TeamViewerManagedGroupId

        $resourceUri = "$(Get-TeamViewerApiUri)/managed/groups/$groupId/devices/$deviceId"

        if ($PSCmdlet.ShouldProcess($deviceId, "Remove device from managed group")) {
            Invoke-TeamViewerRestMethod `
                -ApiToken $ApiToken `
                -Uri $resourceUri `
                -Method Delete `
                -WriteErrorTo $PSCmdlet | `
                Out-Null
        }
    }
}
