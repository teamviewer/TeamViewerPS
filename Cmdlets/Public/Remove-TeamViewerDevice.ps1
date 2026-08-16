function Remove-TeamViewerDevice {
    [CmdletBinding(SupportsShouldProcess = $true)]

    [OutputType([void])]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerDeviceId } )]
        [Alias('DeviceId')]
        [Alias('Id')]
        [object]
        $Device
    )

    process {
        $deviceId = $Device | Resolve-TeamViewerDeviceId
        $resourceUri = "$(Get-TeamViewerApiUri)/devices/$deviceId"
        if ($PSCmdlet.ShouldProcess($deviceId, 'Remove device entry')) {
            Invoke-TeamViewerRestMethod `
                -ApiToken $ApiToken `
                -Uri $resourceUri `
                -Method Delete `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop | `
                Out-Null
        }
    }
}
