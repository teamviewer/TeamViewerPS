function Invoke-TeamViewerPackageDownload {
    param(
        [Parameter()]
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
                $true
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

    if (-not $PackageType) {
        $Package = $host.ui.PromptForChoice('Select Package Type', 'Choose a package type:', `
            @('Full', 'Host', 'MSI32', 'MSI64', 'Portable', 'QuickJoin', 'QuickSupport', 'Full64Bit'), 0)
        $PackageType = @('Full', 'Host', 'MSI32', 'MSI64', 'Portable', 'QuickJoin', 'QuickSupport', 'Full64Bit')[$Package]
    }

    $additionalPath = ''
    $filename = switch ($PackageType) {
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
    if ($MajorVersion) {
        $additionalPath = "/version_$($MajorVersion)x"
    }
    if (($PackageType -eq 'MSI32' -or 'MSI64' )) {
        $additionalPath = '/version_15x'
    }

    $downloadUrl = "https://dl.teamviewer.com/download$additionalPath/$filename"
    $targetFile = Join-Path $TargetDirectory $filename

    if ((Test-Path $targetFile) -and -not $Force -and `
            -not $PSCmdlet.ShouldContinue("File $targetFile already exists. Override?", 'Override existing file?')) {
        return
    }

    Write-Verbose "Downloading $downloadUrl to $targetFile"
    $client = New-Object System.Net.WebClient
    $client.DownloadFile($downloadUrl, $targetFile)

    Write-Output $targetFile
}
