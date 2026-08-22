BeforeDiscovery {
    # Discover all script files in the repository and build parameterized test cases.
    $Script:Module_RootPath = (Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..\..'))
    $Script:Module_PS1Files = @(Get-ChildItem -Path $Module_RootPath -Filter '*.ps1' -File -Recurse -ErrorAction Stop | Sort-Object -Property FullName)

    $Script:Test_Case = $Module_PS1Files |
    ForEach-Object {
        @{
            FilePath     = $_.FullName
            RelativePath = $_.FullName.Substring($Module_RootPath.Path.Length + 1)
        }
    }
}

Describe 'Test-PowershellFilesValidity' {
    # Guard check to ensure discovery produced at least one file to validate.
    It 'Discovers PowerShell files to validate' {
        $Test_Case | Should -Not -BeNullOrEmpty
    }

    # Prevent duplicate test cases for the same path.
    It 'Does not include duplicate file paths' {
        (@($Test_Case.FilePath | Sort-Object -Unique)).Count | Should -Be $Test_Case.Count
    }

    # Ensure discovered files are rooted under repository path.
    It 'Only discovers files under module root path' {
        foreach ($filePath in $Test_Case.FilePath) {
            $filePath.StartsWith($Module_RootPath.Path, [System.StringComparison]::OrdinalIgnoreCase) | Should -BeTrue
        }
    }

    # Ensure each file has a stable, non-empty relative path for test naming and diagnostics.
    It 'Builds non-empty relative paths for discovered files' {
        foreach ($relativePath in $Test_Case.RelativePath) {
            $relativePath | Should -Not -BeNullOrEmpty
        }
    }

    # Parse each script file and assert there are no syntax errors.
    It 'Script should be a valid PowerShell file: <RelativePath>' -TestCases $Test_Case {
        param(
            [string]$FilePath,
            [string]$RelativePath
        )

        $FilePath | Should -Exist

        $tokens = $null
        $parseErrors = $null

        $null = [System.Management.Automation.Language.Parser]::ParseFile($FilePath, [ref]$tokens, [ref]$parseErrors)

        $errorDetails = @($parseErrors | ForEach-Object {
                '{0} (Line {1}, Column {2})' -f $_.Message, $_.Extent.StartLineNumber, $_.Extent.StartColumnNumber
            })

        @($parseErrors).Count | Should -Be 0 -Because "$RelativePath should parse without syntax errors. Errors: $($errorDetails -join '; ')"
    }
}
