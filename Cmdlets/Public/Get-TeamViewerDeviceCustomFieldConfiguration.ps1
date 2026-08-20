function Get-TeamViewerDeviceCustomFieldConfiguration {
    [CmdletBinding()]

    [OutputType('TeamViewerPS.DeviceCustomFieldConfiguration')]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken
    )

    begin {
        $ResourceUri = "$(Get-TeamViewerApiUri)/device-custom-fields"
    }

    process {
        $Response = Invoke-TeamViewerRestMethod `
            -ApiToken $ApiToken `
            -Uri $ResourceUri `
            -Method Get `
            -WriteErrorTo $PSCmdlet `
            -ErrorAction Stop

        Write-Output ($Response.resources | ConvertTo-TeamViewerDeviceCustomFieldConfiguration)
    }
}
