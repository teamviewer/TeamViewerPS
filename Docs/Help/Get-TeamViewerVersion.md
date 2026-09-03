---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/Docs/Help/Get-TeamViewerVersion.md
schema: 2.0.0
---

# Get-TeamViewerVersion

## SYNOPSIS

Retrieve the installed version of TeamViewer.

## SYNTAX

```powershell
Get-TeamViewerVersion [<CommonParameters>]
```

## DESCRIPTION

Returns the version of TeamViewer that is installed on this machine.
Nothing is returned if TeamViewer is not installed.

## EXAMPLES

### Example 1

```powershell
Get-TeamViewerVersion
```

### Example 2

```powershell
$version = Get-TeamViewerVersion
```

Stores the installed TeamViewer version in a variable for later use.

### Example 3

```powershell
if (Get-TeamViewerVersion) { 'TeamViewer is installed' }
```

Checks whether TeamViewer is installed on the local machine.

## PARAMETERS

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

## NOTES

## RELATED LINKS
