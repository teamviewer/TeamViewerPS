function Remove-TeamViewerAssignment {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param()


    if (Test-TeamViewerInstallation) {
        $OS = Get-OperatingSystem
        $CurrentDirectory = Get-Location
        $installationDirectory = Get-TeamViewerInstallationDirectory
        Set-Location $installationDirectory
        if ($OS -eq 'Windows') {
            $cmd = 'unassign'
            $FilePath = 'TeamViewer.exe'
        }
        elseif ($OS -eq 'Linux') {
            $cmd = 'teamviewer unassign'
            $FilePath = 'sudo'
        }
        $process = Start-Process -FilePath $FilePath -ArgumentList $cmd -Wait -PassThru
        $process.ExitCode | Resolve-AssignmentErrorCode
        Set-Location $CurrentDirectory
    }
    else {
        Write-Output 'TeamViewer is not installed.'
    }
}


