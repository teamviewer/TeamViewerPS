function Get-Host {
    param(
        [Parameter(ValueFromPipeline = $true)]
        [string]
        $OutputPath
    )
    process {
        $regPath = 'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters'
        $regKey = Get-ItemProperty -Path $regPath
        $hostsPath = Join-Path -Path $regKey.DataBasePath -ChildPath 'hosts'
        $hostsFile = Get-Content -Path $hostsPath
        $hostsFile | Out-File -FilePath "$OutputPath\Data\hosts.txt"
        Write-Output "hosts file collected and saved to $OutputPath\Data\hosts.txt"
    }
}
