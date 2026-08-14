function Disconnect-TeamViewerApi {
    [CmdletBinding()]

    param()

    $global:PSDefaultParameterValues.Remove('*-Teamviewer*:ApiToken')
}
