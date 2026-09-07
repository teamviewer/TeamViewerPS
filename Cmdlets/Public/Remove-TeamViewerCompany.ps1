function Remove-TeamViewerCompany {
    [CmdletBinding(SupportsShouldProcess = $true)]

    [OutputType([void])]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $APIToken
    )

    $Resource_Uri = "$(Get-TeamViewerAPIUri)/company"

    if ($PSCmdlet.ShouldProcess('TeamViewer company', 'Delete company')) {
        Invoke-TeamViewerRestMethod `
            -APIToken $APIToken `
            -Uri $Resource_Uri `
            -Method Delete `
            -WriteErrorTo $PSCmdlet | `
            Out-Null
    }
}
