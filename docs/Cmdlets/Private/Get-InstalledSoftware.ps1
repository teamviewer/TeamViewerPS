function Get-InstalledSoftware {
    param(
        [Parameter(ValueFromPipeline = $true)]
        [string]
        $OutputPath
    )
    $regUninstall = @{
        InstalledSoftware32 = 'HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall';
        InstalledSoftware64 = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall'
    }
    foreach ($Name in $regUninstall.keys) {
        $regKeys = $regUninstall[$Name]
        $regKey = Get-ItemProperty -Path "$regKeys\*"
        if ($null -ne $regKey) {
            $subKeys = $regKey.PSChildName
            if ($null -ne $subKeys) {
                $installedPrograms = @()
                foreach ($subKey in $subKeys) {
                    $tmpSubkey = Get-ItemProperty -Path "$regKeys\$subKey"
                    $programmName = $tmpSubkey.DisplayName
                    $displayVersion = $tmpSubkey.DisplayVersion
                    if ($null -ne $programmName) {
                        $tmpSoftwareData = "$programmName | $displayVersion"
                        $installedPrograms += $tmpSoftwareData
                    }
                }
            }
            $installedPrograms | Sort-Object | Out-File -FilePath "$OutputPath\Data\$Name.txt"
            Write-Output "$Name collected and saved to $OutputPath\Data\$Name.txt"
        }
    }
}


