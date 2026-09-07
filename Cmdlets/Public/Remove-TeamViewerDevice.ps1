function Remove-TeamViewerDevice {
    [CmdletBinding(SupportsShouldProcess = $true)]

    [OutputType([void])]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $APIToken,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerDeviceId } )]
        [Alias('DeviceId')]
        [Alias('Id')]
        [object]
        $Device
    )

    process {
        $DeviceId = $Device | Resolve-TeamViewerDeviceId
        $Resource_Uri = "$(Get-TeamViewerAPIUri)/devices/$DeviceId"

        if ($PSCmdlet.ShouldProcess($DeviceId, 'Remove device entry')) {
            Invoke-TeamViewerRestMethod `
                -APIToken $APIToken `
                -Uri $Resource_Uri `
                -Method Delete `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop | `
                Out-Null
        }
    }
}
