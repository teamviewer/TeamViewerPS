function Invoke-TeamViewerPackageDownload {
    [CmdletBinding()]

    [OutputType([string])]

    param(
        [Parameter(Mandatory = $true)]
        [ValidateSet('Full', 'Host', 'MSI32', 'MSI64', 'Portable', 'QuickJoin', 'QuickSupport', 'Full64Bit')]
        [Alias('Package')]
        [string]
        $PackageType,

        [Parameter()]
        [ValidateScript( {
                if ($PackageType -eq 'MSI32' -or $PackageType -eq 'MSI64') {
                    $PSCmdlet.ThrowTerminatingError(
                        ('MajorVersion parameter is not supported for MSI packages!' | ConvertTo-ErrorRecord -ErrorCategory InvalidArgument))
                }
                if ($_ -ne 0 -and $_ -lt 14) {
                    $PSCmdlet.ThrowTerminatingError(
                        ("Unsupported TeamViewer version $_" | ConvertTo-ErrorRecord -ErrorCategory InvalidArgument))
                }

                return $true
            } )]
        [Alias('Version')]
        [int]
        $MajorVersion,

        [Parameter()]
        [ValidateScript({ Test-Path -LiteralPath $_ -PathType Container })]
        [Alias('Destination')]
        [string]
        $Path = (Get-Location).Path,

        [Parameter()]
        [switch]
        $Force
    )

    begin {
        $Endpoint_Filename = switch ($PackageType) {
            'Full' {
                'TeamViewer_Setup.exe'
            }
            'MSI32' {
                'TeamViewer_MSI32.zip'
            }
            'MSI64' {
                'TeamViewer_MSI64.zip'
            }
            'Host' {
                'TeamViewer_Host_Setup.exe'
            }
            'Portable' {
                'TeamViewerPortable.zip'
            }
            'QuickJoin' {
                'TeamViewerQJ.exe'
            }
            'QuickSupport' {
                'TeamViewerQS.exe'
            }
            'Full64Bit' {
                'TeamViewer_Setup_x64.exe'
            }
        }

        $Endpoint_Version = ''

        if ($MajorVersion) {
            $Endpoint_Version = "/version_$($MajorVersion)x"
        }

        if ($PackageType -eq 'MSI32' -or $PackageType -eq 'MSI64') {
            $Endpoint_Version = '/version_15x'
        }

        $Endpoint_Url = "https://dl.teamviewer.com/download$Endpoint_Version/$Endpoint_Filename"
        $Target_FilePath = Join-Path -Path $Path -ChildPath $Endpoint_Filename
    }

    process {
        if ((Test-Path -Path $Target_FilePath -PathType Leaf) -and (-not $Force)) {
            Write-Verbose "File '$Target_FilePath' already exists. Use -Force parameter to overwrite."

            Write-Output $null
        }
        else {
            Write-Verbose "Downloading $Endpoint_Url to $Target_FilePath..."

            try {
                Invoke-WebRequest -Uri $Endpoint_Url -OutFile $Target_FilePath -UseBasicParsing -ErrorAction Stop

                Write-Output $Target_FilePath
            }
            catch {
                Write-Verbose "Failed to download TeamViewer package to '$Target_FilePath': $($_.Exception.Message)"

                Write-Output $null
            }
        }
    }
}
