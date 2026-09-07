function Add-TeamViewerAssignment {
    [CmdletBinding(SupportsShouldProcess = $true)]

    [OutputType([void])]

    param(
        [Parameter(Mandatory = $true)]
        [Alias('Id', 'AssignmentId')]
        [object]
        $Assignment,

        [Alias('DeviceAlias')]
        [string]
        $Alias,

        [ValidateRange(1, [int]::MaxValue)]
        [int]
        $Retries
    )

    begin {
        $TV_CurrentVersion = Get-TeamViewerVersion
        $TV_CurrentVersionTable = $TV_CurrentVersion.Split('.')
        $TV_ApplicationFilePath = (Join-Path -Path (Get-TeamViewerInstallationDirectory) -ChildPath 'TeamViewer.exe')
        $TV_AssignmentParams = "assignment --id $Assignment"
    }

    process {
        if (-not (Test-TeamViewerInstallation)) {
            Write-Error 'TeamViewer is not installed!'

            continue
        }

        if ($Alias) {
            if (($TV_CurrentVersionTable[0] -eq 15 -and $TV_CurrentVersionTable[1] -ge 44) -or $TV_CurrentVersionTable[0] -gt 15) {
                $TV_AssignmentParams += " --device-alias=$Alias"
            }
            else {
                Write-Error "Current TeamViewer version ($TV_CurrentVersion) does not support the usage of the alias."

                continue
            }
        }

        if ($Retries) {
            $TV_AssignmentParams += " --retries=$Retries"
        }

        if ($PSCmdlet.ShouldProcess($TV_ApplicationFilePath, 'Add device assignment')) {
            $process = Start-Process -FilePath $TV_ApplicationFilePath -ArgumentList $TV_AssignmentParams -Wait -PassThru
            $process.ExitCode | Resolve-TeamViewerAssignmentErrorCode
        }
    }
}
