function Remove-TeamViewerDeviceCustomField {
    [CmdletBinding(SupportsShouldProcess = $true)]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [Alias('FieldKeyId')]
        [guid]
        $Id
    )

    begin {
        $resourceUri = "$(Get-TeamViewerApiUri)/device-custom-fields/$Id"
    }

    process {
        if ($PSCmdlet.ShouldProcess($Id, 'Delete device custom field')) {
            Invoke-TeamViewerRestMethod `
                -ApiToken $ApiToken `
                -Uri $resourceUri `
                -Method Delete `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop | `
                Out-Null
        }
    }
}
