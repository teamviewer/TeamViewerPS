function Get-TeamViewerCustomModuleId {

    if (Test-TeamViewerinstallation) {
        $fileName = 'TeamViewer.json'
        $installationDirectory = Get-TeamViewerInstallationDirectory
        $filePath = Join-Path -Path $installationDirectory -ChildPath $fileName
        if (Test-Path -Path $filePath) {
            $jsonContent = Get-Content -Path $FilePath -Raw
            $jsonObject = ConvertFrom-Json $jsonContent
            if ($jsonObject.id) {
                return $jsonObject.id
            }
        }
        else {
            Write-Error 'Custom module Id cannot be found. Check if customization is applied.'
        }
    }
    else {
        Write-Error 'TeamViewer is not installed'
    }

}
