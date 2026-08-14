function Connect-TeamViewerApi {
    [CmdletBinding()]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken
    )

    if (Invoke-TeamViewerPing -ApiToken $ApiToken) {
        $global:PSDefaultParameterValues["*-Teamviewer*:ApiToken"] = $ApiToken
    }
}
