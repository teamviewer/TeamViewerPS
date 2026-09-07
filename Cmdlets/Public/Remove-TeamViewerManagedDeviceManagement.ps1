function Remove-TeamViewerManagedDeviceManagement {
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
        $Device
    )

    process {
        $DeviceId = $Device | Resolve-TeamViewerManagedDeviceId

        $Resource_Uri = "$(Get-TeamViewerAPIUri)/managed/devices/$DeviceId"

        if ($PSCmdlet.ShouldProcess($DeviceId, 'Remove Management from a device (clears all managers and groups)')) {
            Invoke-TeamViewerRestMethod `
                -APIToken $APIToken `
                -Uri $Resource_Uri `
                -Method Delete `
                -WriteErrorTo $PSCmdlet | `
                Out-Null
        }
    }
}
