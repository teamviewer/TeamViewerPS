function Get-RouteTable {
    param(
        [Parameter(ValueFromPipeline = $true)]
        [string]
        $OutputPath
    )

    try {
        $processInfo = New-Object System.Diagnostics.ProcessStartInfo
        $processInfo.FileName = 'route.exe'
        $processInfo.Arguments = 'print'
        $processInfo.WindowStyle = 'Hidden'
        $processInfo.UseShellExecute = $false
        $processInfo.RedirectStandardOutput = $true

        $process = [System.Diagnostics.Process]::Start($processInfo)
        $output = $process.StandardOutput.ReadToEnd()
        $output | Out-File "$OutputPath\Data\RouteTable.txt"
    }
    catch {
        Write-Error "An error occurred while collecting RouteTable data: $_"
    }
}
