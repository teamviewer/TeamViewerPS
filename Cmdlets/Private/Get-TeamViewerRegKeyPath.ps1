function Get-TeamViewerRegKeyPath {
    param (
        [Parameter()]
        [ValidateSet('WOW6432', 'Auto')]
        [string]
        $Variant = 'Auto'
    )

    process {
        if (($Variant -eq 'WOW6432') -or (Test-TeamViewer32on64)) {
            'HKLM:\SOFTWARE\Wow6432Node\TeamViewer'
        }

        else {
            'HKLM:\SOFTWARE\TeamViewer'
        }
    }
}
