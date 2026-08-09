$scriptPath = Split-Path -Parent $PSCommandPath
$Repo_RootPath = (Split-Path -Parent (Split-Path -Parent (Split-Path -Parent $scriptPath)))

Describe 'Option A Compliance - Pipeline Output Pattern' {
    <#
    .SYNOPSIS
    Verify that all PowerShell files follow Option A: Process blocks use implicit
    pipeline emission (no return or Write-Output); non-pipeline functions use
    explicit return statements.

    This ensures consistent pipeline semantics across the codebase.
    #>

    It 'Should have no return statements in Process blocks' {
        # Find all .ps1 files (excluding test files which may use various patterns)
        $files = @(
            Get-ChildItem -Path (Join-Path $Repo_RootPath 'Cmdlets') -Recurse -Filter '*.ps1'
            Get-ChildItem -Path (Join-Path $Repo_RootPath 'Build') -Recurse -Filter '*.ps1'
        )

        $violations = @()
        foreach ($file in $files) {
            $content = Get-Content $file.FullName -Raw
            # Detect process blocks containing return statements
            if ($content -match 'process\s*\{[^}]*\breturn\s') {
                $violations += $file.FullName
            }
        }

        $violations | Should -BeNullOrEmpty -Because 'Process blocks must use implicit pipeline'
    }

    It 'Should have no Write-Output in Process blocks for pipeline functions' {
        $files = @(
            Get-ChildItem -Path (Join-Path $Repo_RootPath 'Cmdlets') -Recurse -Filter '*.ps1'
        )

        $violations = @()

        foreach ($file in $files) {
            $content = Get-Content $file.FullName -Raw
            # Detect explicit Write-Output in process blocks (pipeline should be implicit)
            # Only flag if Write-Output is used without piping (direct emission)
            if ($content -match 'process\s*\{[^}]*Write-Output\s+\$[a-zA-Z_]') {
                $violations += $file.FullName
            }
        }

        $violations | Should -BeNullOrEmpty -Because 'Process blocks should use implicit pipeline, not Write-Output'
    }
}
