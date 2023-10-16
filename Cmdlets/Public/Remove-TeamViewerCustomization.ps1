function Remove-TeamViewerCustomization {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param()

    if (Get-OperatingSystem -eq 'Windows') {
        if (Test-TeamViewerInstallation) {
            $installationDirectory = Get-TeamViewerInstallationDirectory
            $currentDirectory = Get-Location
            Set-Location $installationDirectory
            $cmd = 'customize --remove'
            if ($PSCmdlet.ShouldProcess($installationDirectory, 'Remove Client Customization')) {
                $process = Start-Process -FilePath TeamViewer.exe -ArgumentList $cmd -Wait -PassThru
                $process.ExitCode | Resolve-CustomizationErrorCode
            }
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
