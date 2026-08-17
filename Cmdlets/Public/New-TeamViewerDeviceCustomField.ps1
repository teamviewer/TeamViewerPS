function New-TeamViewerDeviceCustomField {
    [CmdletBinding(SupportsShouldProcess = $true)]

    [OutputType('TeamViewerPS.DeviceCustomField')]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true)]
        [string]
        $FieldKey,

        [Parameter()]
        [AllowEmptyString()]
        [string]
        $Description
    )

    begin {
        $body = @{
            fieldKey = $FieldKey
        }

        if ($PSBoundParameters.ContainsKey('Description')) {
            $body['description'] = $Description
        }

        $resourceUri = "$(Get-TeamViewerApiUri)/device-custom-fields"
    }

    process {
        if ($PSCmdlet.ShouldProcess($FieldKey, 'Create device custom field')) {
            $response = Invoke-TeamViewerRestMethod `
                -ApiToken $ApiToken `
                -Uri $resourceUri `
                -Method Post `
                -ContentType 'application/json; charset=utf-8' `
                -Body ([System.Text.Encoding]::UTF8.GetBytes(($body | ConvertTo-Json))) `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop

            Write-Output ($response | ConvertTo-TeamViewerDeviceCustomField)
        }
    }
}
