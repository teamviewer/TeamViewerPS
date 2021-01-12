function Get-OperatingSystem {
    if ($IsLinux) {
        return 'Linux'
    }
    if ($IsMacOS) {
        return 'MacOS'
    }
    if ($IsWindows -Or $env:OS -match '^Windows') {
        return 'Windows'
    }
}
