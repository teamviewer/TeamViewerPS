---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/docs/commands/Get-TeamViewerManagementId.md
schema: 2.0.0
---

# Get-TeamViewerManagementId

## SYNOPSIS

Returns the TeamViewer Management ID of the locally installed TeamViewer.

## SYNTAX

```powershell
Get-TeamViewerManagementId
```

## DESCRIPTION

Returns the TeamViewer Management ID of the locally installed TeamViewer if the
device is managed in the Managed Groups system.
Returns nothing if either TeamViewer is not installed or the device is not a
managed device in the Managed Groups system.
For example, the management ID can be used as `DeviceId` for the
`Get-TeamViewerManagedDevice` command (and all other Managed Device/Group
related commands). 

## EXAMPLES

### Example 1

```powershell
PS /> Get-TeamViewerManagementId
```

## PARAMETERS

## INPUTS

### None

## OUTPUTS

The command returns the Management ID as GUID object.

## NOTES

## RELATED LINKS

[Get-TeamViewerManagedDevice](Get-TeamViewerManagedGroup.md)
