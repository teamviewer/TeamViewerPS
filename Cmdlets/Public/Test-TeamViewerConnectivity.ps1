function Test-TeamViewerConnectivity {
    [CmdletBinding()]

    [OutputType([bool], [pscustomobject])]

    param(
        [Parameter()]
        [switch]
        $Quiet
    )

    begin {
        $tvServices = @(
            [pscustomobject]@{ Hostname = 'account.teamviewer.com'; TcpPort = @(443) }
            [pscustomobject]@{ Hostname = 'chatlivestorage.blob.core.windows.net'; TcpPort = @(443) }
            [pscustomobject]@{ Hostname = 'client.teamviewer.com'; TcpPort = @(443) }
            [pscustomobject]@{ Hostname = 'configdl.teamviewer.com'; TcpPort = @(443) }
            [pscustomobject]@{ Hostname = 'download.teamviewer.com'; TcpPort = @(443) }
            [pscustomobject]@{ Hostname = 'feedbackservice.teamviewer.com'; TcpPort = @(443) }
            [pscustomobject]@{ Hostname = 'get.teamviewer.com'; TcpPort = @(443) }
            [pscustomobject]@{ Hostname = 'go.teamviewer.com'; TcpPort = @(443) }
            [pscustomobject]@{ Hostname = 'hapi.teamviewer.com'; TcpPort = @(443) }
            [pscustomobject]@{ Hostname = 'login.teamviewer.com'; TcpPort = @(443) }
            [pscustomobject]@{ Hostname = 'meeting.teamviewer.com'; TcpPort = @(443) }
            [pscustomobject]@{ Hostname = 'remotescriptingstorage.blob.core.windows.net'; TcpPort = @(443) }
            [pscustomobject]@{ Hostname = 'sso.teamviewer.com'; TcpPort = @(443) }
            [pscustomobject]@{ Hostname = 'web.teamviewer.com'; TcpPort = @(443) }
            [pscustomobject]@{ Hostname = 'webapi.teamviewer.com'; TcpPort = @(443) }
        )

        foreach ($routerIndex in 1..16) {
            $tvServices += [pscustomobject]@{ Hostname = "router$routerIndex.teamviewer.com"; TcpPort = @(5938, 443, 80) }
        }
    }

    process {
        $results = foreach ($tvService in $tvServices) {
            $successfulPort = $null

            foreach ($port in $tvService.TcpPort) {
                Write-Verbose "Checking service $($tvService.Hostname) on port $port..."

                if (Test-NetConnection -ComputerName $tvService.Hostname -Port $port -InformationLevel Quiet -WarningAction SilentlyContinue) {
                    $successfulPort = $port
                    break
                }
            }

            [pscustomobject]@{
                Hostname  = $tvService.Hostname
                TcpPort   = if ($null -ne $successfulPort) {
                    $successfulPort
                }
                else {
                    $tvService.TcpPort
                }

                Succeeded = $null -ne $successfulPort
            }
        }

        if ($Quiet) {
            -not ($results.Succeeded -contains $false)
        }
        else {
            $results | Sort-Object -Property Hostname
        }
    }
}
