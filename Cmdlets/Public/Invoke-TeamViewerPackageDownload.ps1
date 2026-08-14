function Invoke-TeamViewerPackageDownload {
    [CmdletBinding()]

    param(
        [Parameter(Mandatory = $true)]
        [ValidateSet('Full', 'Host', 'MSI32', 'MSI64', 'Portable', 'QuickJoin', 'QuickSupport', 'Full64Bit')]
        [string]
        $PackageType,

        [Parameter()]
        [ValidateScript( {
                if ($PackageType -eq 'MSI32' -or $PackageType -eq 'MSI64') {
                    $PSCmdlet.ThrowTerminatingError(
                        ('MajorVersion parameter is not supported for MSI packages' | `
                            ConvertTo-ErrorRecord -ErrorCategory InvalidArgument))
                }
                if ($_ -ne 0 -and $_ -lt 14) {
                    $PSCmdlet.ThrowTerminatingError(
                        ("Unsupported TeamViewer version $_" | `
                            ConvertTo-ErrorRecord -ErrorCategory InvalidArgument))
                }

                return $true
            } )]
        [int]
        $MajorVersion,

        [Parameter()]
        [ValidateScript({ Test-Path -LiteralPath $_ -PathType Container })]
        [string]
        $TargetDirectory = (Get-Location).Path,

        [Parameter()]
        [switch]
        $Force
    )

    begin {
        $Filename = switch ($PackageType) {
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

        $VersionEndpoint = ''

        if ($MajorVersion) {
            $VersionEndpoint = "/version_$($MajorVersion)x"
        }

        if ($PackageType -eq 'MSI32' -or $PackageType -eq 'MSI64') {
            $VersionEndpoint = '/version_15x'
        }

        $Download_Url = "https://dl.teamviewer.com/download$VersionEndpoint/$Filename"
        $Target_FilePath = Join-Path -Path $TargetDirectory -ChildPath $Filename
    }

    process {
        if ((Test-Path -Path $Target_FilePath -PathType Leaf) -and (-not $Force)) {
            Write-Verbose "File '$Target_FilePath' already exists. Use -Force parameter to overwrite."

            Write-Output $null
        }
        else {
            Write-Verbose "Downloading $Download_Url to $Target_FilePath..."

            try {
                Invoke-WebRequest -Uri $Download_Url -OutFile $Target_FilePath -UseBasicParsing -ErrorAction Stop

                Write-Output $Target_FilePath
            }
            catch {
                Write-Verbose "Failed to download TeamViewer package to '$Target_FilePath': $($_.Exception.Message)"

                Write-Output $null
            }
        }
    }
}
