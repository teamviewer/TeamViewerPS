function Get-TeamViewerCustomModuleId {
    if (Test-TeamViewerInstallation) {
        $TV_AssignmentFilePath = (Join-Path -Path (Get-TeamViewerInstallationDirectory) -ChildPath 'TeamViewer.json')

        if (Test-Path -Path $TV_AssignmentFilePath) {
            try {
                $TV_AssignmentJson = Get-Content -Path $TV_AssignmentFilePath -Raw -ErrorAction Stop
                $jsonObject = ConvertFrom-Json $TV_AssignmentJson

                if ($jsonObject.id) {
                    return $jsonObject.id
                }
            }
            catch {
                Write-Verbose "Failed to read the custom module ID from '$TV_AssignmentFilePath': $($_.Exception.Message)"

                return $null
            }
        }
        else {
            Write-Verbose 'Custom module Id cannot be found. Check if customization is applied.'

            return $null
        }
    }
    else {
        Write-Verbose 'TeamViewer is not installed!'

        return $null
    }
}
