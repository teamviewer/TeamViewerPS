function Add-TeamViewerCustomization {
    [CmdletBinding(SupportsShouldProcess = $true)]

    [OutputType([void])]

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

    begin {
        $TV_ApplicationFilePath = (Join-Path -Path (Get-TeamViewerInstallationDirectory) -ChildPath 'TeamViewer.exe')
        $TV_AssignmentParams = 'customize'

        if ($Id) {
            $TV_AssignmentParams += " --id $Id"
        }

        if ($Path) {
            $TV_AssignmentParams += " --path $Path"
        }

        if ($RestartGUI) {
            $TV_AssignmentParams += ' --restart-gui'
        }

        if ($RemoveExisting) {
            $TV_AssignmentParams += ' --remove'
        }
    }

    process {
        if (-not (Test-TeamViewerInstallation)) {
            Write-Error 'TeamViewer is not installed!'

            continue
        }

        if ($PSCmdlet.ShouldProcess($TV_ApplicationFilePath, 'Add customization')) {
            $process = Start-Process -FilePath $TV_ApplicationFilePath -ArgumentList $TV_AssignmentParams -Wait -PassThru
            $process.ExitCode | Resolve-TeamViewerCustomizationErrorCode
        }
    }
}
