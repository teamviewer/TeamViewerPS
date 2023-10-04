function Get-NSLookUpData {
    param(
        [Parameter(ValueFromPipeline = $true)]
        [string]
        $OutputPath
    )
    Begin {
        $Ipv4DnsServer = @($null, 'tv-ns1.teamviewer.com', 'tv-ns2.teamviewer.com', 'tv-ns3.teamviewer.com',
            'tv-ns4.teamviewer.com', 'tv-ns5.teamviewer.com', '8.8.8.8', '1.1.1.1')
        $Ipv4DnsName = @( 'master1.teamviewer.com', 'router1.teamviewer.com', 'google.com',
            'login.teamviewer.com', 'www.teamviewer.com')
        $output = $null
    }
    Process {
        try {
            foreach ($DnsName in $Ipv4DnsName ) {
                foreach ($DnsServer in $Ipv4DnsServer) {
                    Write-Output "Collecting nslookup.exe information from $DnsName $DnsServer. This might take a while"
                    $output += "nslookup information for:  $DnsName  $DnsServer `r`n"
                    $arguments = "-debug ""$DnsName"""
                    if ($DnsServer) {
                        $arguments += " ""$DnsServer"""
                    }
                    $processInfo = New-Object System.Diagnostics.ProcessStartInfo
                    $processInfo.FileName = 'nslookup.exe'
                    $processInfo.Arguments = $arguments
                    $processInfo.WindowStyle = 'Hidden'
                    $processInfo.UseShellExecute = $false
                    $processInfo.RedirectStandardOutput = $true

                    $process = [System.Diagnostics.Process]::Start($processInfo)
                    $output += $process.StandardOutput.ReadToEnd()
                    $process.WaitForExit(60000)
                    if (-not $process.HasExited) {
                        $process.Kill()
                        continue
                    }
                    $output += $process.StandardOutput.ReadToEnd()
                }
            }
            $output | Out-File "$OutputPath\Data\nslookup.txt"
        }

        catch {
            Write-Error "Error collecting nslookup information: $_"
        }
    }
}


