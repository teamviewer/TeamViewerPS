function Get-TSCSearchDirectory {
    $LocalAppData = [System.Environment]::GetFolderPath('LocalApplicationData')
    $RoamingAppData = [System.Environment]::GetFolderPath('ApplicationData')
    $TVAppData = Join-Path -Path $LocalAppData.ToString() -ChildPath 'TeamViewer/Logs'
    $TVRoamingData = Join-Path -Path $RoamingAppData.ToString() -ChildPath 'TeamViewer'
    $InstallationDirectory = Get-TeamViewerInstallationDirectory

    $TSCSearchDirectory = @{
        'TeamViewer_Version15' = $InstallationDirectory
        'AppData\TeamViewer'   = @($TVAppData; $TVRoamingData)
    }

    return $TSCSearchDirectory
}
