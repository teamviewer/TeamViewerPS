function Get-MSInfo32 {
    param(
        [Parameter(ValueFromPipeline = $true)]
        [string]
        $OutputPath
    )
    Process {
        try {
            Start-Process -FilePath msinfo32.exe -ArgumentList "/nfo $OutputPath\Data\msinfo32.nfo" -Wait

            Write-Output "msinfo data collected and saved to $OutputPath\Data\msinfo32.nfo"
        }
        catch {
            Write-Error "An error occurred while collecting msinfo data: $_"
        }
    }
}
