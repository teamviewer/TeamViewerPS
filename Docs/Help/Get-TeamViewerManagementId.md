---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/Docs/Help/Get-TeamViewerManagementId.md
schema: 2.0.0
---

# Get-TeamViewerManagementId

## SYNOPSIS

Returns the TeamViewer Management Id of the locally installed TeamViewer.

## SYNTAX

```powershell
Get-TeamViewerManagementId
```

## DESCRIPTION

Returns the TeamViewer Management Id of the locally installed TeamViewer if the device is managed in the managed groups system.
Returns nothing if either TeamViewer is not installed or the device is not a managed device in the managed groups system.
For example, the management Id can be used as `DeviceId` for the `Get-TeamViewerManagedDevice` command (and all other managed device / group related commands). 

## EXAMPLES

### Example 1

```powershell
PS /> Get-TeamViewerManagementId
```

## PARAMETERS

## INPUTS

### None

## OUTPUTS

## NOTES

## RELATED LINKS

[Get-TeamViewerManagedDevice](Get-TeamViewerManagedDevice.md)
