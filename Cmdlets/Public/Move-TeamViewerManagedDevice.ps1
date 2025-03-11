function Move-TeamViewerManagedDevice {
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
        [Alias("Source GroupId")]
        [object]
        $SourceGroup,

        [Parameter(Mandatory = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerManagedGroupId } )]
        [Alias("Target GroupId")]
        [object]
        $TargetGroup
    )

    $deviceId = $Device | Resolve-TeamViewerManagedDeviceId
    $sourceGroupId = $SourceGroup | Resolve-TeamViewerManagedGroupId
    $targetGroupId = $TargetGroup | Resolve-TeamViewerManagedGroupId
    $resourceUri = "$(Get-TeamViewerApiUri)/managed/devices/$deviceId/groups"

    $body = @{
        AddedChainIds = @($targetGroupId)
        RemovedChainIds = @($sourceGroupId)
    }

    if ($PSCmdlet.ShouldProcess($deviceId, "Move a device from one group to another")) {
        Invoke-TeamViewerRestMethod `
            -ApiToken $ApiToken `
            -Uri $resourceUri `
            -Method Put `
            -ContentType "application/json; charset=utf-8" `
            -Body ([System.Text.Encoding]::UTF8.GetBytes(($body | ConvertTo-Json))) `
            -WriteErrorTo $PSCmdlet | `
            Out-Null
    }
}
