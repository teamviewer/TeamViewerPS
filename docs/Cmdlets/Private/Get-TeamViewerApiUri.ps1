

class TeamViewerConfiguration {
    [string]$APIUri = 'https://webapi.teamviewer.com/api/v1'

    static [TeamViewerConfiguration] $Instance = $null

    static [TeamViewerConfiguration] GetInstance() {
        if (-not [TeamViewerConfiguration]::Instance) {
            [TeamViewerConfiguration]::Instance = [TeamViewerConfiguration]::new()
        }

        return [TeamViewerConfiguration]::Instance
    }
}

function Get-TeamViewerAPIUri {
    $config = [TeamViewerConfiguration]::GetInstance()
    return $config.APIUri
}


