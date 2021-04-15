function Get-TeamViewerManagementId {
    if (Test-TeamViewerInstallation) {
        switch (Get-OperatingSystem) {
            'Windows' {
                $regKeyPath = Join-Path (Get-TeamViewerRegKeyPath) 'DeviceManagementV2'
                $regKey = if (Test-Path -LiteralPath $regKeyPath) { Get-Item -Path $regKeyPath }
                if ($regKey) {
                    $unmanaged = [bool]($regKey.GetValue('Unmanaged'))
                    $managementId = $regKey.GetValue('ManagementId')
                }
            }
            'Linux' {
                $unmanaged = [bool](Get-TeamViewerLinuxGlobalConfig -Name 'DeviceManagementV2\Unmanaged')
                $managementId = Get-TeamViewerLinuxGlobalConfig -Name 'DeviceManagementV2\ManagementId'
            }
        }
        if (!$unmanaged -And $managementId) {
            Write-Output ([guid]$managementId)
        }
    }
}
