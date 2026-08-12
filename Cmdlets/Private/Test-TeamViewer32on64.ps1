function Test-TeamViewer32on64 {
    param()

    if (-not([Environment]::Is64BitOperatingSystem)) {
        return $false
    }

    $TV_RegKey = Get-TeamViewerRegKeyPath -Variant WOW6432

    if (-not (Test-Path -Path $TV_RegKey -PathType Container)) {
        return $false
    }

    try {
        $TV_InstallationDirectory = (Get-Item -Path $TV_RegKey).GetValue('InstallationDirectory')
        $TV_AppFilePath = (Join-Path -Path $TV_InstallationDirectory -ChildPath 'TeamViewer.exe')

        return Test-Path -Path $TV_AppFilePath
    }
    catch {
        return $false
    }
}
