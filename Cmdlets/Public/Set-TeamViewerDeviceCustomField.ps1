function Set-TeamViewerDeviceCustomField {
    [CmdletBinding(SupportsShouldProcess = $true)]

    [OutputType('TeamViewerPS.DeviceCustomField')]

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
        $FieldConfigurationId,

        [Parameter(Mandatory = $true)]
        [string]
        $Value
    )

    begin {
        $ManagedDeviceId_Resolved = $ManagedDeviceId | Resolve-TeamViewerManagedDeviceId
        $ResourceUri = "$(Get-TeamViewerApiUri)/managed/devices/$ManagedDeviceId_Resolved/custom-fields/$FieldConfigurationId"

        $Body = @{
            value = $Value
        }
    }

    process {
        if ($PSCmdlet.ShouldProcess($FieldConfigurationId, 'Set device custom field value')) {
            $Response = Invoke-TeamViewerRestMethod `
                -ApiToken $ApiToken `
                -Uri $ResourceUri `
                -Method Post `
                -ContentType 'application/json; charset=utf-8' `
                -Body ([System.Text.Encoding]::UTF8.GetBytes(($Body | ConvertTo-Json))) `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop

            Write-Output ($Response | ConvertTo-TeamViewerDeviceCustomField)
        }
    }
}
