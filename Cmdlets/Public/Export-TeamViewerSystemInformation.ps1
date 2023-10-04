function Export-TeamViewerSystemInformation {
    param(
        [Parameter(ValueFromPipeline = $true)]
        [string]
        $TargetDirectory
    )
    Process {
        if (Test-TeamViewerInstallation ) {
            if (Get-OperatingSystem -eq 'Windows') {
                $Temp = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), [System.Guid]::NewGuid().ToString())
                $CurrentDirectory = Get-Location
                $Temp | Get-TSCDirectoryFile
                $Temp | Get-InstalledSoftware
                $Temp | Get-IpConfig
                $Temp | Get-MSInfo32
                $Temp | Get-HostFile
                $Temp | Get-NSLookUpData
                $Temp | Get-RouteTable
                $Temp | Get-RegistryPath
                $ClientID = Get-ClientId
                $ZipFileName = 'TV_SC_' + $ClientID + '_WINPS.zip'
                $ZipPath = Join-Path -Path "$Temp\Data" -ChildPath $ZipFileName
                Compress-Archive -Path $Temp\* -DestinationPath $ZipPath -Force
                if ($TargetDirectory -and (Test-Path $TargetDirectory)) {
                    Copy-Item -Path $ZipPath -Destination $TargetDirectory -Force
                }
                else {
                    Copy-Item -Path $ZipPath -Destination $CurrentDirectory -Force
                }
            }
            else {
                Write-Error 'Currently this functionality is supported only on Windows.'
            }
        }
        else {
            Write-Error 'TeamViewer is not installed.'
        }
    }
}
