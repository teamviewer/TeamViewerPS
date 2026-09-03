---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/Docs/Help/Test-TeamViewerInstallation.md
schema: 2.0.0
---

# Test-TeamViewerInstallation

## SYNOPSIS

Check if TeamViewer is installed on this machine.

## SYNTAX

```powershell
Test-TeamViewerInstallation [<CommonParameters>]
```

## DESCRIPTION

Test if TeamViewer is installed on this machine.
The command simply returns `True` if installed, or `False` otherwise.

## EXAMPLES

### Example 1

```powershell
Test-TeamViewerInstallation
```

### Example 2

```powershell
$isInstalled = Test-TeamViewerInstallation
```

Stores the result of the installation check in the `$isInstalled` variable for later use.

### Example 3

```powershell
if (Test-TeamViewerInstallation) { Restart-TeamViewerService }
```

Restarts the TeamViewer service only when TeamViewer is installed on the machine.

## PARAMETERS

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

## NOTES

## RELATED LINKS
