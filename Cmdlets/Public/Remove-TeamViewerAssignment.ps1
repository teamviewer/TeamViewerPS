function Remove-TeamViewerAssignment {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param()


    if (Test-TeamViewerInstallation) {
        $CurrentDirectory = Get-Location
        $installationDirectory = Get-TeamViewerInstallationDirectory
        Set-Location $installationDirectory
        $cmd = 'unassign'
        $FilePath = 'TeamViewer.exe'
        if ($PSCmdlet.ShouldProcess($installationDirectory, 'Remove device assignment')) {
            $process = Start-Process -FilePath $FilePath -ArgumentList $cmd -Wait -PassThru
            $process.ExitCode | Resolve-AssignmentErrorCode
            Set-Location $CurrentDirectory
        }
    }
    else {
        Write-Output 'TeamViewer is not installed.'
    }
}


