---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/Docs/Help/Get-TeamViewerCustomModuleId.md
schema: 2.0.0
---

# Get-TeamViewerCustomModuleId

## SYNOPSIS

Retrieves the currently applied TeamViewer custom module's Id.

## SYNTAX

```powershell
Get-TeamViewerCustomModuleId
```

## DESCRIPTION

The command checks the TeamViewer Installation and returns the custom module Id.

## EXAMPLES

### Example 1

```powershell
Get-TeamViewerCustomModuleId
```

Returns the custom module id.

### Example 2

```powershell
$moduleId = Get-TeamViewerCustomModuleId
```

Retrieves the custom module Id and stores the result in a variable.

### Example 3

```powershell
if (Get-TeamViewerCustomModuleId) { 'Customization applied' }
```

Uses the returned custom module Id to check whether a customization is applied to the installation.

## PARAMETERS

### CommonParameters

## INPUTS

### None

## OUTPUTS

## NOTES

## RELATED LINKS
