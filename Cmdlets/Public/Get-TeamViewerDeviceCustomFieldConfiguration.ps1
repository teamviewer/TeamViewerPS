function Get-TeamViewerDeviceCustomFieldConfiguration {
    [CmdletBinding()]

    [OutputType('TeamViewerPS.DeviceCustomFieldConfiguration')]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $APIToken
    )

    begin {
        $ResourceUri = "$(Get-TeamViewerAPIUri)/device-custom-fields"
    }

    process {
        $Response = Invoke-TeamViewerRestMethod `
            -APIToken $APIToken `
            -Uri $ResourceUri `
            -Method Get `
            -WriteErrorTo $PSCmdlet `
            -ErrorAction Stop

        Write-Output ($Response.resources | ConvertTo-TeamViewerDeviceCustomFieldConfiguration)
    }
}
