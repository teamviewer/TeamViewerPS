function Get-TeamViewerManagementId {
    [CmdletBinding()]

    param()

    if (Test-TeamViewerInstallation) {
        try {
            $RegKey_Path = Join-Path -Path (Get-TeamViewerRegKeyPath) -ChildPath 'DeviceManagementV2'

            $RegKey = if (Test-Path -LiteralPath $RegKey_Path) {
                Get-Item -Path $RegKey_Path
            }

            if ($RegKey) {
                $IsUnmanaged = [bool]($RegKey.GetValue('Unmanaged'))
                $ManagementId = $RegKey.GetValue('ManagementId')
            }

            if (-not $IsUnmanaged -and $ManagementId) {
                Write-Output ([guid]$ManagementId)
            }
        }
        catch {
            Write-Verbose "Failed to read the TeamViewer management ID: $($_.Exception.Message)"

            return $null
        }
    }
    else {
        Write-Verbose 'TeamViewer is not installed!'

        return $null
    }
}
