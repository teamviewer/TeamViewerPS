function New-TeamViewerDeviceCustomFieldConfiguration {
    [CmdletBinding(SupportsShouldProcess = $true)]

    [OutputType('TeamViewerPS.DeviceCustomFieldConfiguration')]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $APIToken,

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

        $Resource_Uri = "$(Get-TeamViewerAPIUri)/device-custom-fields"
    }

    process {
        if ($PSCmdlet.ShouldProcess($FieldKey, 'Create device custom field')) {
            $Response = Invoke-TeamViewerRestMethod `
                -APIToken $APIToken `
                -Uri $Resource_Uri `
                -Method Post `
                -ContentType 'application/json; charset=utf-8' `
                -Body ([System.Text.Encoding]::UTF8.GetBytes(($Body | ConvertTo-Json))) `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop

            Write-Output ($Response | ConvertTo-TeamViewerDeviceCustomFieldConfiguration)
        }
    }
}
