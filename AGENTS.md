# AGENTS.md

Comprehensive guidance for AI coding agents and developers working in this repository.

## Project Overview

TeamViewerPS is a PowerShell module for the TeamViewer Web API and local TeamViewer client management.
Targets Windows PowerShell 5.1 and PowerShell 6+ on Windows.

| Path | Purpose |
| --- | --- |
| `Cmdlets/Public` | Exported cmdlets |
| `Cmdlets/Private` | Internal converters, resolvers, and helpers |
| `Tests/Public` | Public-cmdlet tests |
| `Tests/Private` | Private-helper tests |
| `Docs/` | User and contributor documentation |

## Workflow

Run commands from the repository root:

```powershell
Invoke-ScriptAnalyzer -Path . -Recurse -Settings .\Linters\PSScriptAnalyzer.psd1
Invoke-Pester -Path .
Invoke-Build -Task Build
```

- Do not hardcode tokens, credentials, or machine-specific values.
- Reuse existing private helpers before adding abstractions.
- Run lint and Pester before finishing.

## PowerShell Conventions

- Use Microsoft approved PowerShell verbs <https://learn.microsoft.com/en-us/powershell/scripting/developer/cmdlet/approved-verbs-for-windows-powershell-commands?view=powershell-7.6> and PascalCase function and variable names.
- Public cmdlets use the `TeamViewer` noun prefix. Private mappers use `ConvertTo-*`; identifier lookups use `Resolve-*`.
- Use `[CmdletBinding()]` for public cmdlets. Add `SupportsShouldProcess = $true` for mutating commands that call `ShouldProcess`.
- Add an empty `param()` block to parameterless advanced functions.
- Use `begin`, `process`, and `end` only when their lifecycle behavior is useful.
- Use `return` for control flow. Emit pipeline output intentionally; use `Write-Output` where explicit output improves clarity, especially in `process` blocks.
- Declare `[OutputType()]` when the public output contract is clear. Match it to runtime output and the help file's `OUTPUTS` section. Use CLR types for primitive values, `[void]` for no output, and existing `TeamViewerPS.*` types for converted objects.

## Parameters And Input

- Validate stable constraints at the boundary with `ValidateSet`, `ValidateRange`, or `ValidateScript`.
- Prefer existing `Resolve-*` helpers for flexible identifiers. Do not reject valid API values with overly strict validation.
- Keep parameter-set names descriptive, such as `ByParameters`, `FilteredList`, or `ByUserId`.
- Use established aliases such as `Id`, `DisplayName`, and `EmailAddress` where they improve a cmdlet's normal use.

## API, Errors, And Objects

- Build URIs with `Get-TeamViewerApiUri`.
- Send requests through `Invoke-TeamViewerRestMethod`. Pass `-WriteErrorTo $PSCmdlet` when the caller should receive REST errors.
- Build request bodies as hashtables and serialize UTF-8 JSON. Add optional fields only when supplied.
- Catch only failures that need local handling. Use `-ErrorAction Stop` inside a `try` when required. Do not catch resolver validation errors.
- Use `ConvertTo-ErrorRecord` and `ConvertTo-TeamViewerRestError` for REST error mapping.
- Converters map API fields to PascalCase properties, assign the existing `TeamViewerPS.*` type name, and emit the typed object. Parse optional dates defensively.
- Handle `SecureString` values with the established marshal-and-zero-memory pattern. Never log plaintext secrets.

## Tests And Documentation

- Add or update Pester coverage for every behavior change. Bug fixes need a regression test.
- Mock external calls and assert request method, URI, token, and JSON body where relevant.
- Keep test variables PascalCase. Test files match their target function name and live in the matching `Tests/Public` or `Tests/Private` folder.
- For public behavior changes, update the dedicated help file, `Docs/TeamViewerPS.md`, and `CHANGELOG.md` when user-visible.
- Keep the module manifest's exported functions alphabetized when adding or removing a public cmdlet.
