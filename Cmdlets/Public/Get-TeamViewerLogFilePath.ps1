function Get-TeamViewerLogFilePath {
    [CmdletBinding()]

    param()

    begin {
        $TV_RoamingData = Join-Path -Path $env:APPDATA -ChildPath 'TeamViewer'
        $TV_AppData = Join-Path -Path $env:LOCALAPPDATA -ChildPath 'TeamViewer/Logs'

        $TV_SearchDirectories = @{
            'TeamViewer_Version15' = Get-TeamViewerInstallationDirectory
            'AppData\TeamViewer'   = @($TV_AppData; $TV_RoamingData)
        }

        $TV_ExcludedLogFileNames = @(
            'TV15Install.log',
            'TVNetwork.log',
            'TVNetwork_Old.log',
            '1EClient-install.log',
            'TeamViewer15_Hooks.log',
            'TeamViewer15_Hooks_Old.log'
        )
    }

    process {
        if (-not (Test-TeamViewerInstallation)) {
            Write-Error 'TeamViewer is not installed!'

            continue
        }

        foreach ($SearchDirectory in $TV_SearchDirectories.Values) {
            foreach ($Folder in @($SearchDirectory)) {
                if (-not (Test-Path -Path $Folder)) {
                    continue
                }

                Get-ChildItem -Path $Folder -File -Recurse -Filter '*.log' | Where-Object { $_.Name -notin $TV_ExcludedLogFileNames } | Select-Object -ExpandProperty FullName
            }
        }
    }
}
