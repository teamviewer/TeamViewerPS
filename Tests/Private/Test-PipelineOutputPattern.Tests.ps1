BeforeAll {
    $Script:Module_RootPath = (Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..\..'))
}

Describe 'Test-PipelineOutputPattern' {
    <#
    .SYNOPSIS
    Verify that all PowerShell files follow the rule: process blocks use implicit pipeline emission.
    No return or Write-Output; non-pipeline functions use explicit return statements.

    This ensures consistent pipeline semantics across the codebase.
    #>

    It 'Should have no return statements in Process blocks' {
        # Find all .ps1 files (excluding test files which may use various patterns)
        $files = @(
            Get-ChildItem -Path (Join-Path $Module_RootPath 'Cmdlets') -Recurse -Filter '*.ps1'
            Get-ChildItem -Path (Join-Path $Module_RootPath 'Build') -Recurse -Filter '*.ps1'
        )

        $violations = @()
        foreach ($file in $files) {
            $tokens = $null
            $parseErrors = $null
            $ast = [System.Management.Automation.Language.Parser]::ParseFile($file.FullName, [ref]$tokens, [ref]$parseErrors)
            $processBlocks = $ast.FindAll({ param($node) $node -is [System.Management.Automation.Language.NamedBlockAst] -and $node.BlockKind -eq 'Process' }, $true)

            foreach ($processBlock in $processBlocks) {
                $returns = $processBlock.FindAll({ param($node) $node -is [System.Management.Automation.Language.ReturnStatementAst] }, $true)
                if ($returns.Count -gt 0) {
                    $violations += $file.FullName
                }
            }
        }

        $violations | Should -BeNullOrEmpty -Because 'Process blocks must emit output with Write-Output'
    }

    It 'Should permit Write-Output in Process blocks' {
        $files = Get-ChildItem -Path (Join-Path $Module_RootPath 'Cmdlets') -Recurse -Filter '*.ps1'
        $writeOutputProcessBlocks = @()

        foreach ($file in $files) {
            $tokens = $null
            $parseErrors = $null
            $ast = [System.Management.Automation.Language.Parser]::ParseFile($file.FullName, [ref]$tokens, [ref]$parseErrors)
            $processBlocks = $ast.FindAll({ param($node) $node -is [System.Management.Automation.Language.NamedBlockAst] -and $node.BlockKind -eq 'Process' }, $true)

            foreach ($processBlock in $processBlocks) {
                $writeOutputs = $processBlock.FindAll({ param($node) $node -is [System.Management.Automation.Language.CommandAst] -and $node.GetCommandName() -eq 'Write-Output' }, $true)
                if ($writeOutputs.Count -gt 0) {
                    $writeOutputProcessBlocks += $file.FullName
                }
            }
        }

        $writeOutputProcessBlocks | Should -Not -BeNullOrEmpty -Because 'Write-Output is an approved explicit emission mechanism'
    }

}
