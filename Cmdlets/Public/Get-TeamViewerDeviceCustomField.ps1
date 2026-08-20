function Get-TeamViewerDeviceCustomField {
    [CmdletBinding()]

    [OutputType('TeamViewerPS.DeviceCustomField')]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerManagedDeviceId } )]
        [Alias('DeviceId')]
        [object]
        $ManagedDeviceId
    )

    process {
        $ManagedDeviceIdResolved = $ManagedDeviceId | Resolve-TeamViewerManagedDeviceId
        $ResourceUri = "$(Get-TeamViewerApiUri)/managed/devices/$ManagedDeviceIdResolved/custom-fields"

        $Response = Invoke-TeamViewerRestMethod `
            -ApiToken $ApiToken `
            -Uri $ResourceUri `
            -Method Get `
            -WriteErrorTo $PSCmdlet `
            -ErrorAction Stop

        $Response.customFieldValues | ConvertTo-TeamViewerDeviceCustomField
    }
}
