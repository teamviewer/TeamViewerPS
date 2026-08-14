function Get-TeamViewerDeviceCustomField {
    [CmdletBinding()]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken
    )

    begin {
        $resourceUri = "$(Get-TeamViewerApiUri)/device-custom-fields"
    }

    process {
        $response = Invoke-TeamViewerRestMethod `
            -ApiToken $ApiToken `
            -Uri $resourceUri `
            -Method Get `
            -WriteErrorTo $PSCmdlet `
            -ErrorAction Stop

        Write-Output ($response.resources | ConvertTo-TeamViewerDeviceCustomField)
    }
}
