function Get-TeamViewerDeviceCustomFieldConfiguration {
    [CmdletBinding()]

    [OutputType('TeamViewerPS.DeviceCustomFieldConfiguration')]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $APIToken
    )

    begin {
        $Resource_Uri = "$(Get-TeamViewerAPIUri)/device-custom-fields"
    }

    process {
        $Response = Invoke-TeamViewerRestMethod `
            -APIToken $APIToken `
            -Uri $Resource_Uri `
            -Method Get `
            -WriteErrorTo $PSCmdlet `
            -ErrorAction Stop

        Write-Output ($Response.resources | ConvertTo-TeamViewerDeviceCustomFieldConfiguration)
    }
}
