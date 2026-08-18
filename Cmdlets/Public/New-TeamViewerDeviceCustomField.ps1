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
        $Body = @{
            fieldKey = $FieldKey
        }

        if ($PSBoundParameters.ContainsKey('Description')) {
            $Body['description'] = $Description
        }

        $ResourceUri = "$(Get-TeamViewerApiUri)/device-custom-fields"
    }

    process {
        if ($PSCmdlet.ShouldProcess($FieldKey, 'Create device custom field')) {
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
