Function Add-TeamViewerCustomization {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ParameterSetName = 'ById')]
        [object]
        $Id,

        [Parameter(Mandatory = $true, ParameterSetName = 'ByPath')]
        [object]
        $Path,

        [switch]
        $RestartGUI,

        [switch]
        $RemoveExisting
    )

    if (Get-OperatingSystem -eq 'Windows') {
        if (Test-TeamViewerInstallation) {
            $installationDirectory = Get-TeamViewerInstallationDirectory
            $currentDirectory = Get-Location
            Set-Location $installationDirectory
            $cmd = 'customize'
            if ($Id) {
                $cmd += " --id $Id"
            }
            elseif ($Path) {
                $cmd += " --path $Path"
            }
            if ($RemoveExisting) {
                $cmd += ' --remove'
            }
            if ($RestartGUI) {
                $cmd += ' --restart-gui'
            }
            $process = Start-Process -FilePath TeamViewer.exe -ArgumentList $cmd -Wait -PassThru
            $process.ExitCode | Resolve-CustomizationErrorCode
            Set-Location $currentDirectory
        }
        else {
            Write-Error 'TeamViewer is not installed'
        }
    }
    else {
        Write-Error 'Customization is currently supported only on Windows.'
    }
}
