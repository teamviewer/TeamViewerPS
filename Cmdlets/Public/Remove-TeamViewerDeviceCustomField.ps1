function Remove-TeamViewerDeviceCustomField {
    [CmdletBinding(SupportsShouldProcess = $true)]

    [OutputType([void])]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerManagedDeviceId } )]
        [Alias('ManagedDevice', 'Device', 'DeviceId')]
        [object]
        $ManagedDeviceId,

        [Parameter(Mandatory = $true)]
        [Alias('FieldKeyId')]
        [guid]
        $FieldConfigurationId
    )

    process {
        $ManagedDeviceId_Resolved = $ManagedDeviceId | Resolve-TeamViewerManagedDeviceId
        $ResourceUri = "$(Get-TeamViewerApiUri)/managed/devices/$ManagedDeviceId_Resolved/custom-fields/$FieldConfigurationId"

        if ($PSCmdlet.ShouldProcess($FieldConfigurationId, 'Delete device custom field value')) {
            Invoke-TeamViewerRestMethod `
                -ApiToken $ApiToken `
                -Uri $ResourceUri `
                -Method Delete `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop | `
                Out-Null
        }
    }
}
