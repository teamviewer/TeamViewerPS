function Get-TeamViewerManagementId {
    if (Test-TeamViewerInstallation) {
        $regKeyPath = Join-Path (Get-TeamViewerRegKeyPath) 'DeviceManagementV2'
        $regKey = if (Test-Path -LiteralPath $regKeyPath) { Get-Item -Path $regKeyPath }
        if ($regKey) {
            $unmanaged = [bool]($regKey.GetValue('Unmanaged'))
            $managementId = $regKey.GetValue('ManagementId')
        }
        if (!$unmanaged -And $managementId) {
            Write-Output ([guid]$managementId)
        }
    }
}
