function Add-TeamViewerManagedDevice {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true)]
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

    $deviceId = $Device | Resolve-TeamViewerManagedDeviceId
    $groupId = $Group | Resolve-TeamViewerManagedGroupId
    $resourceUri = "$(Get-TeamViewerApiUri)/managed/groups/$groupId/devices"

    $body = @{
        id = $deviceId
    }

    if ($PSCmdlet.ShouldProcess($deviceId, "Add device to managed group")) {
        Invoke-TeamViewerRestMethod `
            -ApiToken $ApiToken `
            -Uri $resourceUri `
            -Method Post `
            -ContentType "application/json; charset=utf-8" `
            -Body ([System.Text.Encoding]::UTF8.GetBytes(($body | ConvertTo-Json))) `
            -WriteErrorTo $PSCmdlet | `
            Out-Null
    }
}
