---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/Docs/Help/Get-TeamViewerId.md
schema: 2.0.0
---

# Get-TeamViewerId

## SYNOPSIS

Returns the TeamViewer Id of the locally installed TeamViewer.

## SYNTAX

```powershell
Get-TeamViewerId [<CommonParameters>]
```

## DESCRIPTION

Returns the TeamViewer Id of the locally installed TeamViewer. This Id can be used to connect to this machine.
Returns nothing if TeamViewer is not installed on this machine.

## EXAMPLES

### Example 1

```powershell
Get-TeamViewerId
```

Returns the TeamViewer Id of the locally installed client.

### Example 2

```powershell
$tvid = Get-TeamViewerId
```

Stores the TeamViewer installation directory path in the variable `$tvid`.

### Example 3

```powershell
Get-TeamViewerId | Set-Clipboard
```

Copies the local TeamViewer Id to the clipboard.

## PARAMETERS

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

## NOTES

## RELATED LINKS
