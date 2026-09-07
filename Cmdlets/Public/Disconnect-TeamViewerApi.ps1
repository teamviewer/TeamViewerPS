function Disconnect-TeamViewerAPI {
    [CmdletBinding()]

    [OutputType([void])]

    param()

    $global:PSDefaultParameterValues.Remove('*-Teamviewer*:APIToken')
}
