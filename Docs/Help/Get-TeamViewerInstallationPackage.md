---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/Docs/Help/Get-TeamViewerInstallationPackage.md
schema: 2.0.0
---

# Get-TeamViewerInstallationPackage

## SYNOPSIS

Returns the installed TeamViewer package type (Full or Host).

## SYNTAX

```powershell
Get-TeamViewerInstallationPackage [<CommonParameters>]
```

## DESCRIPTION

The command checks the installed TeamViewer executable and returns the package type based on the file metadata.
It returns `Full` for full client installations, `Host` for host installations, or nothing if the package type cannot be determined.

## EXAMPLES

### Example 1

```powershell
PS /> Get-TeamViewerInstallationPackage
```

Returns `Full` or `Host` depending on the installed TeamViewer package.

## PARAMETERS

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.String

Returns `Full`, `Host`, or `$null` when the package type cannot be determined.

## NOTES

## RELATED LINKS

[Get-TeamViewerInstallationDirectory](Get-TeamViewerInstallationDirectory.md)

[Test-TeamViewerInstallation](Test-TeamViewerInstallation.md)
