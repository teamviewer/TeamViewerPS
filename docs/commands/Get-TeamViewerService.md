---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/docs/commands/Get-TeamViewerService.md
schema: 2.0.0
---

# Get-TeamViewerService

## SYNOPSIS

Return the current state of the TeamViewer service.

## SYNTAX

```powershell
Get-TeamViewerService [<CommonParameters>]
```

## DESCRIPTION

Returns the current state of the TeamViewer service.
This is platform dependent.

On Windows platforms, the command will return the service object of the
TeamViewer service.

On Linux platforms, the command will output the current state (running, stopped,
etc.) of the TeamViewer service.

## EXAMPLES

### Example 1

```powershell
PS C:\> Get-TeamViewerService
```

## PARAMETERS

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

## NOTES

## RELATED LINKS
