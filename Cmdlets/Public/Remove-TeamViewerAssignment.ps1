function Remove-TeamViewerAssignment {
    [CmdletBinding(SupportsShouldProcess = $true)]

    param()

    begin {
        $TV_ApplicationFilePath = (Join-Path -Path (Get-TeamViewerInstallationDirectory) -ChildPath 'TeamViewer.exe')
        $TV_AssignmentParams = 'unassign'
    }

    process {
        if (-not (Test-TeamViewerInstallation)) {
            Write-Error 'TeamViewer is not installed!'

            continue
        }

        if ($PSCmdlet.ShouldProcess($TV_ApplicationFilePath, 'Remove device assignment')) {
            $process = Start-Process -FilePath $TV_ApplicationFilePath -ArgumentList $TV_AssignmentParams -Wait -PassThru
            $process.ExitCode | Resolve-TeamViewerAssignmentErrorCode
        }
    }
}
