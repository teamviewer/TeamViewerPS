function Get-TeamViewerRegKeyPath {
    param (
        [Parameter()]
        [ValidateSet('WOW6432', 'Auto')]
        [string]
        $Variant = 'Auto'
    )
    if (($Variant -eq 'WOW6432') -Or (Test-TeamViewer32on64)) {
        Write-Output 'HKLM:\SOFTWARE\Wow6432Node\TeamViewer'
    }
    else {
        Write-Output 'HKLM:\SOFTWARE\TeamViewer'
    }
}
