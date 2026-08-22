function Remove-TeamViewerCustomization {
    [CmdletBinding(SupportsShouldProcess = $true)]

    [OutputType([void])]

    param()

    begin {
        $TV_ApplicationFilePath = (Join-Path -Path (Get-TeamViewerInstallationDirectory) -ChildPath 'TeamViewer.exe')
        $TV_AssignmentParams = 'customize --remove'
    }

    process {
        if (-not (Test-TeamViewerInstallation)) {
            Write-Error 'TeamViewer is not installed!'

            continue
        }

        if ($PSCmdlet.ShouldProcess($TV_ApplicationFilePath, 'Remove device customization')) {
            $process = Start-Process -FilePath $TV_ApplicationFilePath -ArgumentList $TV_AssignmentParams -Wait -PassThru
            $process.ExitCode | Resolve-TeamViewerCustomizationErrorCode
        }
    }
}
