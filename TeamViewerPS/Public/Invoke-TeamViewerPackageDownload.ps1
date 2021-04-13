function Invoke-TeamViewerPackageDownload {
    Param(
        [Parameter()]
        [ValidateSet('Full', 'Host', 'Portable', 'QuickJoin', 'QuickSupport', 'Full64Bit')]
        [ValidateScript( {
                if (($_ -ne 'Full') -And ((Get-OperatingSystem) -ne 'Windows')) {
                    $PSCmdlet.ThrowTerminatingError(
                        ("PackageType parameter is only supported on Windows platforms" | `
                                ConvertTo-ErrorRecord -ErrorCategory InvalidArgument))
                }
                $true
            })]
        [string]
        $PackageType = 'Full',

        [Parameter()]
        [ValidateScript( {
                if ((Get-OperatingSystem) -ne 'Windows') {
                    $PSCmdlet.ThrowTerminatingError(
                        ("MajorVersion parameter is only supported on Windows platforms" | `
                                ConvertTo-ErrorRecord -ErrorCategory InvalidArgument))
                }
                if ($_ -lt 14) {
                    $PSCmdlet.ThrowTerminatingError(
                        ("Unsupported TeamViewer version $_" | `
                                ConvertTo-ErrorRecord -ErrorCategory InvalidArgument))
                }
                $true
            } )]
        [int]
        $MajorVersion,

        [Parameter()]
        [string]
        $TargetDirectory = (Get-Location).Path,

        [Parameter()]
        [switch]
        $Force
    )

    $additionalPath = ''
    switch (Get-OperatingSystem) {
        'Windows' {
            $filename = switch ($PackageType) {
                'Full' { 'TeamViewer_Setup.exe' }
                'Host' { 'TeamViewer_Host_Setup.exe' }
                'Portable' { 'TeamViewerPortable.zip' }
                'QuickJoin' { 'TeamViewerQJ.exe' }
                'QuickSupport' { 'TeamViewerQS.exe' }
                'Full64Bit' { 'TeamViewer_Setup_x64.exe' }
            }
            if ($MajorVersion) {
                $additionalPath = "/version_$($MajorVersion)x"
            }
        }
        'Linux' {
            $releaseInfo = (Get-Content /etc/*-release)
            $filename = switch -Regex ($releaseInfo) {
                'debian|ubuntu' {
                    $platform = if ([Environment]::Is64BitOperatingSystem) { 'amd64' } else { 'i386' }
                    "teamviewer_$platform.deb"
                }
                'centos|rhel|fedora' {
                    $platform = if ([Environment]::Is64BitOperatingSystem) { 'x86_64' } else { 'i686' }
                    "teamviewer.$platform.rpm"
                }
                'suse|opensuse' {
                    $platform = if ([Environment]::Is64BitOperatingSystem) { 'x86_64' } else { 'i686' }
                    "teamviewer-suse.$platform.rpm"
                }
            }
            $filename = $filename | Select-Object -First 1
            $additionalPath = '/linux'
        }
    }

    $downloadUrl = "https://download.teamviewer.com/download$additionalPath/$filename"
    $targetFile = Join-Path $TargetDirectory $filename

    if ((Test-Path $targetFile) -And -Not $Force -And `
            -Not $PSCmdlet.ShouldContinue("File $targetFile already exists. Override?", "Override existing file?")) {
        return
    }

    Write-Verbose "Downloading $downloadUrl to $targetFile"
    $client = New-Object System.Net.WebClient
    $client.DownloadFile($downloadUrl, $targetFile)
    Write-Output $targetFile
}
