---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/Docs/Help/Get-TeamViewerInstallationType.md
schema: 2.0.0
---

# Get-TeamViewerInstallationType

## SYNOPSIS

Returns the TeamViewer installation type.

## SYNTAX

```powershell
Get-TeamViewerInstallationType 
```

## DESCRIPTION

The command checks the TeamViewer installation and returns the installation type (MSI or exe) and $null when it could not be determined.

## EXAMPLES

### Example 1

```powershell
Get-TeamViewerInstallationType
```

Returns the installation type of TeamViewer (MSI, exe or Unknown).

### Example 2

```powershell
$type = Get-TeamViewerInstallationType
```

Stores the installation type (Msi, Exe, or Unknown) in a variable.

### Example 3

```powershell
if ((Get-TeamViewerInstallationType) -eq 'Msi') { Write-Output 'TeamViewer was installed via MSI' }
```

Checks whether TeamViewer was installed using an MSI package.

## PARAMETERS

### CommonParameters

## INPUTS

### None

## OUTPUTS

### System.String

Returns a string indicating the installation type: "MSI", "exe", or "Unknown".

## NOTES

## RELATED LINKS
