function Test-TeamViewerInstallation {
    [CmdletBinding()]

    param()

    if (Get-TeamViewerInstallationDirectory) {
        return $true
    }
    else {
        return $false
    }
}
