function Get-TeamViewerDeviceCustomField {
    [CmdletBinding()]

    [OutputType('TeamViewerPS.DeviceCustomField')]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerManagedDeviceId } )]
        [Alias('ManagedDevice', 'Device', 'DeviceId')]
        [object]
        $ManagedDeviceId
    )

    process {
        $ManagedDeviceId_Resolved = $ManagedDeviceId | Resolve-TeamViewerManagedDeviceId
        $ResourceUri = "$(Get-TeamViewerApiUri)/managed/devices/$ManagedDeviceId_Resolved/custom-fields"

        $Response = Invoke-TeamViewerRestMethod `
            -ApiToken $ApiToken `
            -Uri $ResourceUri `
            -Method Get `
            -WriteErrorTo $PSCmdlet `
            -ErrorAction Stop

        $Response.customFieldValues | ConvertTo-TeamViewerDeviceCustomField
    }
}
