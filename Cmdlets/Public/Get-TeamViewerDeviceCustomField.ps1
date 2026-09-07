function Get-TeamViewerDeviceCustomField {
    [CmdletBinding()]

    [OutputType('TeamViewerPS.DeviceCustomField')]

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
        $ManagedDeviceId_Resolved = $Device | Resolve-TeamViewerManagedDeviceId
        $ResourceUri = "$(Get-TeamViewerAPIUri)/managed/devices/$ManagedDeviceId_Resolved/custom-fields"

        $Response = Invoke-TeamViewerRestMethod `
            -APIToken $APIToken `
            -Uri $ResourceUri `
            -Method Get `
            -WriteErrorTo $PSCmdlet `
            -ErrorAction Stop

        $Response.customFieldValues | ConvertTo-TeamViewerDeviceCustomField
    }
}
