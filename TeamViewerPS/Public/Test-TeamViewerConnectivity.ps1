function Test-TeamViewerConnectivity {
    param(
        [Parameter()]
        [switch]
        $Quiet
    )

    $endpoints = @(
        @{ Hostname = 'webapi.teamviewer.com'; TcpPort = 443; }
        @{ Hostname = 'login.teamviewer.com'; TcpPort = 443; }
        @{ Hostname = 'meeting.teamviewer.com'; TcpPort = 443; }
        @{ Hostname = 'sso.teamviewer.com'; TcpPort = 443; }
        @{ Hostname = 'download.teamviewer.com'; TcpPort = 443; }
        @{ Hostname = 'configdl.teamviewer.com'; TcpPort = 443; }
        @{ Hostname = 'get.teamviewer.com'; TcpPort = 443; }
        @{ Hostname = 'go.teamviewer.com'; TcpPort = 443; }
        @{ Hostname = 'client.teamviewer.com'; TcpPort = 443; }
        @{ Hostname = 'feedbackservice.teamviewer.com'; TcpPort = 443; }
        @{ Hostname = 'remotescriptingstorage.blob.core.windows.net'; TcpPort = 443; }
        @{ Hostname = 'chatlivestorage.blob.core.windows.net'; TcpPort = 443; }
    )
    1..16 | ForEach-Object {
        $endpoints += @{ Hostname = "router$_.teamviewer.com"; TcpPort = (5938, 443, 80) }
    }

    $results = $endpoints | ForEach-Object {
        $endpoint = $_
        $portSucceeded = $endpoint.TcpPort | Where-Object {
            Write-Verbose "Checking endpoint $($endpoint.Hostname) on port $_"
            Test-TcpConnection -Hostname $endpoint.Hostname -Port $_
        } | Select-Object -First 1
        $endpoint.Succeeded = [bool]$portSucceeded
        $endpoint.TcpPort = if ($endpoint.Succeeded) { $portSucceeded } else { $endpoint.TcpPort }
        return $endpoint
    }

    if ($Quiet) {
        ![bool]($results | Where-Object { -Not $_.Succeeded })
    }
    else {
        $results | `
            ForEach-Object { New-Object PSObject -Property $_ } | `
            Select-Object -Property Hostname, Succeeded, TcpPort
    }
}
