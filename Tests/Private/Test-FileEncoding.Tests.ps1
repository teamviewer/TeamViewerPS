BeforeDiscovery {
    $Script:Module_RootPath = (Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..\..'))
    $Script:EncodingExtensions = @(
        '.ps1',
        '.psm1',
        '.psd1',
        '.ps1xml',
        '.md',
        '.json',
        '.yml',
        '.yaml',
        '.xml'
    )

    # Ignore generated package content that is produced during build.
    $Script:ExcludedPathRegex = '(\\|/)Build(\\|/)TeamViewerPS(\\|/)'

    $Script:EncodingTestCases = @(Get-ChildItem -Path $Module_RootPath -Recurse -File -ErrorAction Stop |
        Where-Object {
            $_.Extension.ToLowerInvariant() -in $EncodingExtensions -and $_.FullName -notmatch $ExcludedPathRegex
        } | Sort-Object -Property FullName | ForEach-Object {
            @{
                FilePath     = $_.FullName
                RelativePath = $_.FullName.Substring($Module_RootPath.Path.Length + 1)
            }
        })
}

Describe 'Test-FileEncoding' {
    It 'Discovers files to validate' {
        $EncodingTestCases | Should -Not -BeNullOrEmpty
    }

    It 'File uses UTF-8 BOM encoding: <RelativePath>' -TestCases $EncodingTestCases {
        param(
            [string]$FilePath,
            [string]$RelativePath
        )

        $FilePath | Should -Exist

        [byte[]]$contentBytes = [System.IO.File]::ReadAllBytes($FilePath)

        # Empty files are valid; otherwise require UTF-8 BOM bytes EF BB BF.
        $hasUtf8Bom =
        $contentBytes.Length -eq 0 -or
        (
            $contentBytes.Length -ge 3 -and
            $contentBytes[0] -eq 239 -and
            $contentBytes[1] -eq 187 -and
            $contentBytes[2] -eq 191
        )

        $hasUtf8Bom | Should -BeTrue -Because "$RelativePath should be UTF-8 with BOM according to repository encoding rules"
    }
}
