function Move-TeamViewerManagedDevice {
    [CmdletBinding(SupportsShouldProcess = $true)]

    [OutputType([void])]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $APIToken,

        [Parameter(Mandatory = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerManagedDeviceId } )]
        [Alias('DeviceId')]
        [object]
        $Device,

        [Parameter(Mandatory = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerManagedGroupId } )]
        [Alias('Source GroupId')]
        [object]
        $SourceGroup,

        [Parameter(Mandatory = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerManagedGroupId } )]
        [Alias('Target GroupId')]
        [object]
        $TargetGroup
    )

    $DeviceId = $Device | Resolve-TeamViewerManagedDeviceId
    $SourceGroupId = $SourceGroup | Resolve-TeamViewerManagedGroupId
    $TargetGroupId = $TargetGroup | Resolve-TeamViewerManagedGroupId
    $ResourceUri = "$(Get-TeamViewerAPIUri)/managed/devices/$DeviceId/groups"

    $Body = @{
        AddedChainIds   = @($TargetGroupId.ToString())
        RemovedChainIds = @($SourceGroupId.ToString())
    }

    if ($PSCmdlet.ShouldProcess($DeviceId, 'Move a device from one group to another')) {
        Invoke-TeamViewerRestMethod `
            -APIToken $APIToken `
            -Uri $ResourceUri `
            -Method Put `
            -ContentType 'application/json; charset=utf-8' `
            -Body ([System.Text.Encoding]::UTF8.GetBytes(($Body | ConvertTo-Json))) `
            -WriteErrorTo $PSCmdlet | Out-Null
    }
}
