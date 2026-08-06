function Get-TeamViewerInstallationDirectory {
    $TV_RegKey = Get-TeamViewerRegKeyPath

    if (Test-Path -Path $TV_RegKey -PathType Container) {
        $TV_InstallationDirectory = (Get-Item -Path $TV_RegKey).GetValue('InstallationDirectory')
    }

    if ($TV_InstallationDirectory -and (Test-Path -Path (Join-Path -Path $TV_InstallationDirectory -ChildPath 'TeamViewer.exe'))) {
        return $TV_InstallationDirectory
    }
    else {
        return $null
    }
}
