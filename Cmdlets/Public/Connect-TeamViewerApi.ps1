function Connect-TeamViewerAPI {
    [CmdletBinding()]

    [OutputType([void])]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $APIToken
    )

    if (Invoke-TeamViewerPing -APIToken $APIToken) {
        $global:PSDefaultParameterValues['*-Teamviewer*:APIToken'] = $APIToken
    }
}
