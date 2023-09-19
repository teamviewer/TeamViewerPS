function Add-TeamViewerAssignment {
    param(
        [Parameter(Mandatory = $true)]
        [object]
        $AssignmentId,

        [string]
        $DeviceAlias,

        [int]
        $Retries
    )


    if (Test-TeamViewerInstallation) {
        $OS = Get-OperatingSystem
        $CurrentDirectory = Get-Location
        $installationDirectory = Get-TeamViewerInstallationDirectory
        Set-Location $installationDirectory
        $CurrentVersion = Get-TeamViewerVersion
        $VersionTable = $CurrentVersion.split('.')
        if ($OS -eq 'Windows') {
            $cmd = "assignment --id $AssignmentId"
            $FilePath = 'TeamViewer.exe'
        }
        elseif ($OS -eq 'Linux') {
            $cmd = "teamviewer assignment --id $AssignmentId"
            $FilePath = 'sudo'
        }

        if ($DeviceAlias) {
            if (($VersionTable[0] -eq 15 -and $VersionTable[1] -ge 44) -or $VersionTable[0] -gt 15) {
                $cmd += " --device-alias=$DeviceAlias"
            }
            else {
                Write-Error "Current TeamViewer Version: $CurrentVersion does not support the usage of alias. Please update to the latest version."
                Set-Location $CurrentDirectory
                exit
            }
        }
        if ($Retries) {
            $cmd += " --retries=$Retries"
        }
        $process = Start-Process -FilePath $FilePath -ArgumentList $cmd -Wait -PassThru
        $process.ExitCode | Resolve-AssignmentErrorCode
        Set-Location $CurrentDirectory
    }
    else {
        Write-Output 'TeamViewer is not installed.'
    }
}


