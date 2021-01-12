function Get-TeamViewerRegKeyPath {
    if ([Environment]::Is64BitOperatingSystem) {
        Write-Output 'HKLM:\SOFTWARE\Wow6432Node\TeamViewer'
    }
    else {
        Write-Output 'HKLM:\SOFTWARE\TeamViewer'
    }
}
