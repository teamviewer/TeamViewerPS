function Remove-TeamViewerCompany {
    [CmdletBinding(SupportsShouldProcess = $true)]

    [OutputType([void])]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $APIToken
    )

    $ResourceUri = "$(Get-TeamViewerAPIUri)/company"

    if ($PSCmdlet.ShouldProcess('TeamViewer company', 'Delete company')) {
        Invoke-TeamViewerRestMethod `
            -APIToken $APIToken `
            -Uri $ResourceUri `
            -Method Delete `
            -WriteErrorTo $PSCmdlet | `
            Out-Null
    }
}
