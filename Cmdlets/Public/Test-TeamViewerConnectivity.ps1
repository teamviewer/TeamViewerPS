function Test-TeamViewerConnectivity {
    [CmdletBinding()]

    [OutputType([bool], [pscustomobject])]

    param(
        [Parameter()]
        [switch]
        $Quiet
    )

    begin {
        $TV_Services = @(
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
            $TV_Services += [pscustomobject]@{ Hostname = "router$routerIndex.teamviewer.com"; TcpPort = @(5938, 443, 80) }
        }
    }

    process {
        $Results = foreach ($TV_Service in $TV_Services) {
            $successfulPort = $null

            foreach ($port in $TV_Service.TcpPort) {
                Write-Verbose "Checking service $($TV_Service.Hostname) on port $port..."

                if (Test-NetConnection -ComputerName $TV_Service.Hostname -Port $port -InformationLevel Quiet -WarningAction SilentlyContinue) {
                    $successfulPort = $port
                    break
                }
            }

            [pscustomobject]@{
                Hostname  = $TV_Service.Hostname
                TcpPort   = if ($null -ne $successfulPort) {
                    $successfulPort
                }
                else {
                    $TV_Service.TcpPort
                }

                Succeeded = $null -ne $successfulPort
            }
        }

        if ($Quiet) {
            -not ($Results.Succeeded -contains $false)
        }
        else {
            $Results | Sort-Object -Property Hostname
        }
    }
}
