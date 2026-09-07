function Move-TeamViewerManagedDevice {
    [CmdletBinding(SupportsShouldProcess = $true)]

    [OutputType([void])]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $APIToken,

        [Parameter(Mandatory = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerManagedDeviceId } )]
        [Alias('Id', 'DeviceId', 'ManagedDeviceId', 'ManagedDevice')]
        [object]
        $Device,

        [Parameter(Mandatory = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerManagedGroupId } )]
        [Alias('SourceGroup', 'Source_Group', 'Source_GroupId')]
        [object]
        $Source,

        [Parameter(Mandatory = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerManagedGroupId } )]
        [Alias('TargetGroup', 'Target_Group', 'Target_GroupId')]
        [object]
        $Target
    )

    $Device_Id = $Device | Resolve-TeamViewerManagedDeviceId
    $Source_Id = $Source | Resolve-TeamViewerManagedGroupId
    $Target_Id = $Target | Resolve-TeamViewerManagedGroupId

    $Resource_Uri = "$(Get-TeamViewerAPIUri)/managed/devices/$Device_Id/groups"

    $Body = @{
        AddedChainIds   = @($Target_Id.ToString())
        RemovedChainIds = @($Source_Id.ToString())
    }

    if ($PSCmdlet.ShouldProcess($Device_Id, 'Move a device from one device group to another')) {
        Invoke-TeamViewerRestMethod `
            -APIToken $APIToken `
            -Uri $Resource_Uri `
            -Method Put `
            -ContentType 'application/json; charset=utf-8' `
            -Body ([System.Text.Encoding]::UTF8.GetBytes(($Body | ConvertTo-Json))) `
            -WriteErrorTo $PSCmdlet | Out-Null
    }
}
