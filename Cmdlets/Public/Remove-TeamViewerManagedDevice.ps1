function Remove-TeamViewerManagedDevice {
    [CmdletBinding(SupportsShouldProcess = $true)]

    [OutputType([void])]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $APIToken,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerManagedDeviceId } )]
        [Alias('DeviceId')]
        [object]
        $Device,

        [Parameter(Mandatory = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerManagedGroupId } )]
        [Alias('GroupId')]
        [object]
        $Group
    )

    process {
        $GroupId = $Group | Resolve-TeamViewerManagedGroupId
        $DeviceId = $Device | Resolve-TeamViewerManagedDeviceId
        $ResourceUri = "$(Get-TeamViewerAPIUri)/managed/groups/$GroupId/devices/$DeviceId"

        if ($PSCmdlet.ShouldProcess($DeviceId, 'Remove device from managed group')) {
            Invoke-TeamViewerRestMethod `
                -APIToken $APIToken `
                -Uri $ResourceUri `
                -Method Delete `
                -WriteErrorTo $PSCmdlet | `
                Out-Null
        }
    }
}
