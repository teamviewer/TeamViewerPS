---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/Docs/Help/Get-TeamViewerCustomizationId.md
schema: 2.0.0
---

# Get-TeamViewerCustomizationId

## SYNOPSIS

Retrieves the currently applied TeamViewer customization's (Custom Module) Id.

## SYNTAX

```powershell
Get-TeamViewerCustomizationId
```

## DESCRIPTION

The command checks the TeamViewer installation and returns the customization (Custom Module) Id.

## EXAMPLES

### Example 1

```powershell
Get-TeamViewerCustomizationId
```

Returns the customization id.

### Example 2

```powershell
$moduleId = Get-TeamViewerCustomizationId
```

Retrieves the customization Id and stores the result in a variable.

### Example 3

```powershell
if (Get-TeamViewerCustomizationId) { 'Customization applied' }
```

Uses the returned customization Id to check whether a customization is applied to the installation.

## PARAMETERS

### CommonParameters

## INPUTS

### None

## OUTPUTS

## NOTES

## RELATED LINKS
