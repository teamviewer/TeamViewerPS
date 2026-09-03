---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/Docs/Help/Get-TeamViewerLogFilePath
schema: 2.0.0
---

# Get-TeamViewerLogFilePath

## SYNOPSIS

Retrieves TeamViewer log files.

## SYNTAX

```powershell
Get-TeamViewerLogFilePath
```

## DESCRIPTION

The command checks the required directories and returns the paths for log files.

## EXAMPLES

### Example 1

```powershell
Get-TeamViewerLogFilePath 
```

Returns the paths for log files.

### Example 2

```powershell
$logFiles = Get-TeamViewerLogFilePath
```

Stores the collection of TeamViewer log file paths in a variable.

### Example 3

```powershell
Get-TeamViewerLogFilePath | Where-Object { $_ -like '*Connections*' }
```

Returns only the log file paths whose name contains 'Connections'.

## PARAMETERS

### CommonParameters

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
