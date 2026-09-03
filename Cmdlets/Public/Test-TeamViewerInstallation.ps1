function Test-TeamViewerInstallation {
    [CmdletBinding()]

    [OutputType([bool])]

    param()

    if (Get-TeamViewerInstallationDirectory) {
        return $true
    }
    else {
        return $false
    }
}
