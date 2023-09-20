function Disconnect-TeamViewerApi {
    $global:PSDefaultParameterValues.Remove("*-Teamviewer*:ApiToken")
}