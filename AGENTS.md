# AGENTS.md

Guidance for AI coding agents working in this repository.

## Project Overview

TeamViewerPS is a PowerShell module for the TeamViewer Web API and local TeamViewer client management.
Targets Windows PowerShell 5.1 and PowerShell 6+ on Windows.

| Folder | Purpose |
| --- | --- |
| `Cmdlets/Public` | Exported cmdlets (user-facing) |
| `Cmdlets/Private` | Converters, resolvers, internal helpers |
| `Tests/Public` | Tests for public cmdlets |
| `Tests/Private` | Tests for private helpers |
| `Docs/` | User and contributor documentation / help |

## Canonical Commands

Run from the repository root.

```powershell
# Lint
Invoke-ScriptAnalyzer -Path . -Recurse -Settings .\Linters\PSScriptAnalyzer.psd1

# Test
Invoke-Pester -Path .

# Build (requires Invoke-Build)
Invoke-Build -Task Clean
Invoke-Build -Task Build
Invoke-Build -Task Test
```

## Editing Guidance

- Scope changes to the user request; avoid unrelated refactors.
- Preserve public function names and parameter contracts unless explicitly asked to change them.
- Prefer existing helpers in `Cmdlets/Private` over new abstractions.
- Follow naming conventions: `ConvertTo-*` for mapping, `Resolve-*` for lookups, standard verbs (`Get/Set/New/Remove/Invoke/Test`) for cmdlets.
- Add or update Pester tests for every behavior change; include a regression test for bug fixes.
- Run lint and tests before finishing; both must pass.

## Documentation

- Every public function must appear in `Docs/TeamViewerPS.md` under the correct section, alphabetically within that section.
- Adding or removing a public function requires updating `Docs/TeamViewerPS.md` and the corresponding file in `Docs/Help/`.
- Update `README.md` when user-facing behavior changes.

## Changelog

- Update `CHANGELOG.md` for every user-visible change as part of the same commit.
- Add entries under the top unreleased block (`x.x.x (YYYY-xx-xx)`).
- Use existing headings: `Added`, `Changed`, `Fixed`, `Updated`, `Removed`.
- Keep entries concise and user-facing; include issue links where available.
- Do not reorder or rewrite released sections.

## Pull Request Guidance

- Never hardcode API tokens, credentials, or environment-specific values.
- State what was tested (lint/tests) in the PR description.
- Keep PRs focused; target the `main` branch.
