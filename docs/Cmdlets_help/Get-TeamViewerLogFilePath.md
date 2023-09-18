---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: 
schema: 2.0.0
---

# Get-TeamViewerLogFilePath

## SYNOPSIS

Retrieves TeamViewer log files.

## SYNTAX

```powershell
Get-TeamViewerLogFilePath -OpenFile <switch>
```

## DESCRIPTION

The command checks the required directories and returns the paths for log files.

## EXAMPLES

### Example 1

```powershell
PS /> Get-TeamViewerLogFilePath 
```

Returns the paths for log files.

### Example 2

```powershell
PS /> Get-TeamViewerLogFilePath -OpenFile
```

Provides a prompt with choice to open the located files.

## PARAMETERS

### -OpenFile

Switch to open a log file.

```yaml
Type: switch
Parameter Sets: (All)
Aliases: None

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

### None

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
