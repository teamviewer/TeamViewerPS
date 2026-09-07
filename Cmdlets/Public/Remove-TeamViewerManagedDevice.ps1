function Remove-TeamViewerManagedDevice {
    [CmdletBinding(SupportsShouldProcess = $true)]

    [OutputType([void])]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $APIToken,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerManagedDeviceId } )]
        [Alias('Id', 'DeviceId', 'ManagedDeviceId', 'ManagedDevice')]
        [object]
        $Device,

        [Parameter(Mandatory = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerManagedGroupId } )]
        [Alias('GroupId', 'ManagedGroupId', 'ManagedGroup')]
        [object]
        $Group
    )

    process {
        $GroupId = $Group | Resolve-TeamViewerManagedGroupId
        $DeviceId = $Device | Resolve-TeamViewerManagedDeviceId
        $Resource_Uri = "$(Get-TeamViewerAPIUri)/managed/groups/$GroupId/devices/$DeviceId"

        if ($PSCmdlet.ShouldProcess($DeviceId, 'Remove device from managed group')) {
            Invoke-TeamViewerRestMethod `
                -APIToken $APIToken `
                -Uri $Resource_Uri `
                -Method Delete `
                -WriteErrorTo $PSCmdlet | `
                Out-Null
        }
    }
}
