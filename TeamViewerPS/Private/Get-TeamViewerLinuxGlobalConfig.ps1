function Get-TeamViewerLinuxGlobalConfig {
    param(
        [Parameter()]
        [string]
        $Path = '/opt/teamviewer/config/global.conf',

        [Parameter()]
        [string]
        $Name
    )
    $config = Get-Content $Path | ForEach-Object {
        if ($_ -Match '\[(?<EntryType>\w+)\]\s+(?<EntryName>\w+)\s+=\s*(?<EntryValue>.*)$') {
            $Matches.Remove(0)
            $entry = [pscustomobject]$Matches
            switch ($entry.EntryType) {
                'strng' {
                    $entry.EntryValue = $entry.EntryValue | `
                        Select-String -Pattern '"([^\"]*)"' -AllMatches | `
                        Select-Object -ExpandProperty Matches | `
                        ForEach-Object { $_.Groups[1].Value }
                }
            }
            $entry
        }
    }

    if ($Name) {
        ($config | Where-Object { $_.EntryName -eq $Name }).EntryValue
    }
    else {
        $config
    }
}
