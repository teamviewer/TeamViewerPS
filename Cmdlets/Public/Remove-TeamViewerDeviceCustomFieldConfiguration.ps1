function Remove-TeamViewerDeviceCustomFieldConfiguration {
    [CmdletBinding(SupportsShouldProcess = $true)]

    [OutputType([void])]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $APIToken,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [Alias('FieldKeyId')]
        [guid]
        $Id
    )

    process {
        $ResourceUri = "$(Get-TeamViewerAPIUri)/device-custom-fields/$Id"

        if ($PSCmdlet.ShouldProcess($Id, 'Delete device custom field')) {
            Invoke-TeamViewerRestMethod `
                -APIToken $APIToken `
                -Uri $ResourceUri `
                -Method Delete `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop | `
                Out-Null
        }
    }
}
