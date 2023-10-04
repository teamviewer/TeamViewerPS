---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/Docs/Help/Get-TeamViewerId.md
schema: 2.0.0
---

# Get-TeamViewerId

## SYNOPSIS

Returns the TeamViewer ID of the locally installed TeamViewer.

## SYNTAX

```powershell
Get-TeamViewerId [<CommonParameters>]
```

## DESCRIPTION

Returns the TeamViewer ID of the locally installed TeamViewer. This ID can be
used to connect to this machine.
Returns nothing if TeamViewer is not installed on this machine.

## EXAMPLES

### Example 1

```powershell
PS /> $tvid = Get-TeamViewerId
```

## PARAMETERS

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

## NOTES

## RELATED LINKS
