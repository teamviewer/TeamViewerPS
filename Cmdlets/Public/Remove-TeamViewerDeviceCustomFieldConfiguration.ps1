function Remove-TeamViewerDeviceCustomFieldConfiguration {
    [CmdletBinding(SupportsShouldProcess = $true)]

    [OutputType([void])]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [Alias('FieldKeyId')]
        [guid]
        $Id
    )

    process {
        $ResourceUri = "$(Get-TeamViewerApiUri)/device-custom-fields/$Id"

        if ($PSCmdlet.ShouldProcess($Id, 'Delete device custom field')) {
            Invoke-TeamViewerRestMethod `
                -ApiToken $ApiToken `
                -Uri $ResourceUri `
                -Method Delete `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop | `
                Out-Null
        }
    }
}
