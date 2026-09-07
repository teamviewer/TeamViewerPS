function Remove-TeamViewerDeviceCustomField {
    [CmdletBinding(SupportsShouldProcess = $true)]

    [OutputType([void])]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $APIToken,

        [Parameter(Mandatory = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerManagedDeviceId } )]
        [Alias('Id', 'ManagedDevice', 'Device', 'DeviceId')]
        [object]
        $ManagedDeviceId,

        [Parameter(Mandatory = $true)]
        [Alias('FieldKeyId')]
        [guid]
        $FieldConfigurationId
    )

    process {
        $ManagedDeviceId_Resolved = $ManagedDeviceId | Resolve-TeamViewerManagedDeviceId
        $Resource_Uri = "$(Get-TeamViewerAPIUri)/managed/devices/$ManagedDeviceId_Resolved/custom-fields/$FieldConfigurationId"

        if ($PSCmdlet.ShouldProcess($FieldConfigurationId, 'Delete device custom field value')) {
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
