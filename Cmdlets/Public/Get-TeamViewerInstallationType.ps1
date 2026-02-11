function Get-TeamViewerInstallationType {

    [CmdletBinding()]
    [OutputType([string])]
    param()

    $regPath = 'HKLM:\SOFTWARE\TeamViewer'
    $regPathWow = 'HKLM:\SOFTWARE\WOW6432Node\TeamViewer'
    $MsiDatabaseFound = $false
    $MsiRegistryValueFound = $false



    #first check MSI database
    try {
        $MsiProduct = Get-CimInstance -ClassName Win32_Product -Filter "Name='TeamViewer'" -ErrorAction Stop
        if ($MsiProduct) {
            $MsiDatabaseFound = $true
        }
    }
    catch {
        Write-Verbose "MSI database check failed or TeamViewer not found via WMI"
    }

    #check MsiInstallation value
    foreach ($path in @($regPath, $regPathWow)) {
        try {
            $MsiInstallationValue = Get-ItemProperty -Path $path -Name 'MsiInstallation' -ErrorAction Stop

            if ($null -ne $MsiInstallationValue.MsiInstallation -and $MsiInstallationValue.MsiInstallation -eq 1) {
                $MsiRegistryValueFound = $true
                break
            }
        }
        catch [System.Management.Automation.ItemNotFoundException] {
            Write-Verbose "TeamViewer registry path not found: $path"
        }
        catch {
            Write-Verbose "registry check for MsiInstallation failed at $path"
        }
    }

    if ($MsiDatabaseFound -and $MsiRegistryValueFound) {
        return 'MSI'
    }

    #check for exeInstallation
    try {
        $uninstallPaths = @(
            'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall',
            'HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall'
        )

        foreach ($uninstallPath in $uninstallPaths) {
            if (Test-Path -Path $uninstallPath) {
                $teamViewerKey = Get-ChildItem -Path $uninstallPath -ErrorAction SilentlyContinue | 
                    Where-Object { $_.GetValue('DisplayName') -like '*TeamViewer*' }

                if ($teamViewerKey) {
                    $uninstallValue = Get-ItemProperty -Path $teamViewerKey.PSPath -Name 'UninstallString' -ErrorAction SilentlyContinue
                    if ($uninstallValue -and $uninstallValue.UninstallString) {
                        #extract the executable path using regex
                        $uninstallFile = $uninstallValue.UninstallString -replace '^"?([^"]+)"?.*$', '$1'
                        $uninstallFile = $uninstallFile.Trim('"')
                        #verify if it's a file and if it exists
                        if (Test-Path -Path $uninstallFile -PathType Leaf) {
                            return 'exe'
                        }
                        else {
                            return 'Unknown'
                        }
                    }
                }
            }
        }
    }
    catch {
        Write-Verbose "Error checking UninstallString"
    }

    return 'Unknown'
}
