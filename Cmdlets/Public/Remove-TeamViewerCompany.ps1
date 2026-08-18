function Remove-TeamViewerCompany {
    [CmdletBinding(SupportsShouldProcess = $true)]

    [OutputType([void])]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken
    )

    $ResourceUri = "$(Get-TeamViewerApiUri)/company"

    if ($PSCmdlet.ShouldProcess('TeamViewer company', 'Delete company')) {
        Invoke-TeamViewerRestMethod `
            -ApiToken $ApiToken `
            -Uri $ResourceUri `
            -Method Delete `
            -WriteErrorTo $PSCmdlet | `
            Out-Null
    }
}
