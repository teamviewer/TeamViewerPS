---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/Docs/Help/Disconnect-TeamViewerAPI.md
schema: 2.0.0
---

# Disconnect-TeamViewerAPI

## SYNOPSIS

Removes the TeamViewer API access token from the current environment.

## SYNTAX

```powershell
Disconnect-TeamViewerAPI [<CommonParameters>]
```

## DESCRIPTION

Removes a possibly stored TeamViewer API access token from the current Powershell global scope.

## EXAMPLES

### Example 1

```powershell
Disconnect-TeamViewerAPI
```

Removes a previously stored TeamViewer API access token from the current environment.

### Example 2

```powershell
Connect-TeamViewerAPI
Get-TeamViewerUser
Disconnect-TeamViewerAPI
```

Connects to the API, runs a command and then removes the stored API access token again.

### Example 3

```powershell
Disconnect-TeamViewerAPI -Verbose
```

Removes the stored TeamViewer API access token and shows verbose output about the operation.

## PARAMETERS

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

## NOTES

## RELATED LINKS

[Connect-TeamViewerAPI](Connect-TeamViewerAPI.md)
