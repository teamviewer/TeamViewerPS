---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/Docs/Help/Get-TeamViewerInstallationDirectory.md
schema: 2.0.0
---

# Get-TeamViewerInstallationDirectory

## SYNOPSIS

Retrieves the TeamViewer installation directory.

## SYNTAX

```powershell
Get-TeamViewerInstallationDirectory 
```

## DESCRIPTION

The command checks the TeamViewer Installation and returns the installation directory.

## EXAMPLES

### Example 1

```powershell
Get-TeamViewerInstallationDirectory
```

Returns the installation directory.

### Example 2

```powershell
$installDir = Get-TeamViewerInstallationDirectory
```

Stores the TeamViewer installation directory path in the variable `$installDir`.

### Example 3

```powershell
Join-Path -Path (Get-TeamViewerInstallationDirectory) -ChildPath 'TeamViewer.exe'
```

Builds the full path to the TeamViewer executable from the installation directory.

## PARAMETERS

### CommonParameters

## INPUTS

### None

## OUTPUTS

## NOTES

## RELATED LINKS
