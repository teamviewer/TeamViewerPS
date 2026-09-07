function Add-TeamViewerCustomization {
    [CmdletBinding(SupportsShouldProcess = $true)]

    [OutputType([void])]

    param (
        [Parameter(Mandatory = $true, ParameterSetName = 'ByCustomizationId')]
        [Alias('Id', 'CustomizationId')]
        [object]
        $Customization,

        [Parameter(Mandatory = $true, ParameterSetName = 'ByPath')]
        [object]
        $Path,

        [switch]
        $RestartGUI,

        [switch]
        $Force
    )

    begin {
        $TV_ApplicationFilePath = (Join-Path -Path (Get-TeamViewerInstallationDirectory) -ChildPath 'TeamViewer.exe')
        $TV_AssignmentParams = 'customize'

        if ($Customization) {
            $TV_AssignmentParams += " --id $Customization"
        }

        if ($Path) {
            $TV_AssignmentParams += " --path $Path"
        }

        if ($RestartGUI) {
            $TV_AssignmentParams += ' --restart-gui'
        }

        if ($Force) {
            $TV_AssignmentParams += ' --remove'
        }
    }

    process {
        if (-not (Test-TeamViewerInstallation)) {
            Write-Error 'TeamViewer is not installed!'

            continue
        }

        if ($PSCmdlet.ShouldProcess($TV_ApplicationFilePath, 'Add customization')) {
            $TV_Process = Start-Process -FilePath $TV_ApplicationFilePath -ArgumentList $TV_AssignmentParams -Wait -PassThru
            $TV_Process.ExitCode | Resolve-TeamViewerCustomizationErrorCode
        }
    }
}
