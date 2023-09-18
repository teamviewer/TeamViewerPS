function Get-IpConfig {
    param(
        [Parameter(ValueFromPipeline = $true)]
        [string]
        $OutputPath
    )

    try {
        ipconfig /all | Out-File -FilePath "$OutputPath\Data\ipconfig.txt" -Encoding utf8
        Write-Output "ipconfig data collected and saved to $OutputPath\Data\ipconfig.txt"
    }
    catch {
        Write-Error "An error occurred while collecting ipconfig data: $_"
    }
}
