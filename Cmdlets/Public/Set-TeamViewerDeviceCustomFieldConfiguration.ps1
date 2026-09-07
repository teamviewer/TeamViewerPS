function Set-TeamViewerDeviceCustomFieldConfiguration {
    [CmdletBinding(SupportsShouldProcess = $true)]

    [OutputType('TeamViewerPS.DeviceCustomFieldConfiguration')]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $APIToken,

        [Parameter(Mandatory = $true)]
        [Alias('FieldKeyId')]
        [guid]
        $Id,

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

        $ResourceUri = "$(Get-TeamViewerAPIUri)/device-custom-fields/$Id"
    }

    process {
        if ($PSCmdlet.ShouldProcess($Id, 'Update device custom field')) {
            $Response = Invoke-TeamViewerRestMethod `
                -APIToken $APIToken `
                -Uri $ResourceUri `
                -Method Put `
                -ContentType 'application/json; charset=utf-8' `
                -Body ([System.Text.Encoding]::UTF8.GetBytes(($Body | ConvertTo-Json))) `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop

            Write-Output ($Response | ConvertTo-TeamViewerDeviceCustomFieldConfiguration)
        }
    }
}
