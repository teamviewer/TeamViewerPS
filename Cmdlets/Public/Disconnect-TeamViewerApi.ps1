function Disconnect-TeamViewerApi {
    [CmdletBinding()]

    [OutputType([void])]

    param()

    $global:PSDefaultParameterValues.Remove('*-Teamviewer*:ApiToken')
}
