function Get-TeamViewerInstallationType {
    [CmdletBinding()]

    [OutputType([string])]

    param()

    # Flags to track detection of MSI indicators
    $Msi_UninstallEntryFound = $false
    $Msi_RegistryValueFound = $false

    # Registry paths where Windows stores software uninstall information (32-bit and 64-bit)
    $Uninstall_Paths = @(
        'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall',
        'HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall'
    )

    # Detection Step 1: Check uninstall registry entries for MSI installation marker
    try {
        foreach ($Uninstall_Path in $Uninstall_Paths) {
            if (Test-Path -Path $Uninstall_Path -PathType Container) {
                # Find all TeamViewer entries in the uninstall registry path
                $TV_RegKeys = Get-ChildItem -Path $Uninstall_Path -ErrorAction SilentlyContinue | Where-Object { $_.GetValue('DisplayName') -like '*TeamViewer*' }

                foreach ($TV_RegKey in $TV_RegKeys) {
                    # Check if the 'WindowsInstaller' property is set to 1 (indicates MSI-based installation)
                    $TV_UninstallValue = Get-ItemProperty -Path $TV_RegKey.PSPath -Name 'WindowsInstaller' -ErrorAction SilentlyContinue

                    if ($TV_UninstallValue.WindowsInstaller -eq 1) {
                        $Msi_UninstallEntryFound = $true

                        break
                    }
                }

                if ($Msi_UninstallEntryFound) {
                    break
                }
            }
        }
    }
    catch {
        Write-Verbose 'Failed to check uninstall registry entries for MSI installation.'
    }

    # Detection Step 2: Check TeamViewer's registry configuration for MSI installation flag
    $TV_RegPaths = @(
        Get-TeamViewerRegKeyPath -Variant Auto
        Get-TeamViewerRegKeyPath -Variant WOW6432
    ) | Select-Object -Unique

    foreach ($TV_RegPath in $TV_RegPaths) {
        try {
            # Check for the 'MsiInstallation' value which indicates MSI-based installation
            $TV_MSIFlag = Get-ItemProperty -Path $TV_RegPath -Name 'MsiInstallation' -ErrorAction Stop

            if ($null -ne $TV_MSIFlag.MsiInstallation -and $TV_MSIFlag.MsiInstallation -eq 1) {
                $Msi_RegistryValueFound = $true

                break
            }
        }
        catch {
            Write-Verbose "Unable to access TeamViewer registry path: $TV_RegPath"
        }
    }

    # If both MSI indicators are found, installation is confirmed as MSI
    if ($Msi_UninstallEntryFound -and $Msi_RegistryValueFound) {
        return 'Msi'
    }

    # Detection Step 3: Check for EXE-based installation
    try {
        foreach ($Uninstall_Path in $Uninstall_Paths) {
            if (Test-Path -Path $Uninstall_Path -PathType Container) {
                # Find all TeamViewer entries in the uninstall registry path
                $TV_RegKeys = Get-ChildItem -Path $Uninstall_Path -ErrorAction SilentlyContinue | Where-Object { $_.GetValue('DisplayName') -like '*TeamViewer*' }

                foreach ($TV_RegKey in $TV_RegKeys) {
                    # Extract the uninstall executable path from the registry entry
                    $TV_UninstallValue = Get-ItemProperty -Path $TV_RegKey.PSPath -Name 'UninstallString' -ErrorAction SilentlyContinue

                    if ($TV_UninstallValue -and $TV_UninstallValue.UninstallString) {
                        # Parse the uninstall path, removing quotes and parameters
                        $UninstallFile = $TV_UninstallValue.UninstallString -replace '^"?([^"]+)"?.*$', '$1'
                        $UninstallFile = $UninstallFile.Trim('"')

                        # If the uninstaller executable exists, installation is EXE-based
                        if (Test-Path -Path $UninstallFile -PathType Leaf) {
                            return 'Exe'
                        }
                    }
                }
            }
        }
    }
    catch {
        Write-Verbose 'Failed to check uninstall registry entries for EXE installation.'
    }

    # No installation type was detected
    return 'Unknown'
}
