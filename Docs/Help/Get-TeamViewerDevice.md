---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/Docs/Help/Get-TeamViewerDevice.md
schema: 2.0.0
---

# Get-TeamViewerDevice

## SYNOPSIS

Returns the devices of the current account's Computers & Contacts list.

## SYNTAX

### FilteredList (Default)

```powershell
Get-TeamViewerDevice -ApiToken <SecureString> [-TeamViewerId <Int32>] [-FilterBy_OnlineState <String>]
 [-Group <Object>] [<CommonParameters>]
```

### ByDevice

```powershell
Get-TeamViewerDevice -ApiToken <SecureString> [-Device <String>] [<CommonParameters>]
```

## DESCRIPTION

Returns a list of contacts in the user's Computers & Contacts list that match the criteria given in the parameters.

## EXAMPLES

### Example 1

```powershell
Get-TeamViewerDevice
```

List all devices of the Computers & Contacts list.

### Example 2

```powershell
Get-TeamViewerDevice -Device 'd1234'
```

Get the device entry with the given Id.

### Example 3

```powershell
Get-TeamViewerDevice -Group 'g1234' -FilterBy_OnlineState 'Online'
```

List only the online devices that are part of the group with the given group Id.

## PARAMETERS

### -ApiToken

The TeamViewer API access token.

```yaml
Type: SecureString
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FilterBy_OnlineState

Optional filter for devices in a certain online state.

```yaml
Type: String
Parameter Sets: FilteredList
Aliases:
Accepted values: Online, Busy, Away, Offline

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Group

Object that can be used to identify the group.
This can either be the group Id or a group object that has been received using other module functions.
If given, the command only returns device entries that are part of that group.

```yaml
Type: Object
Parameter Sets: FilteredList
Aliases: GroupId

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Device

Device identifier used to get only a single specific device list entry.

```yaml
Type: String
Parameter Sets: ByDevice
Aliases: Id, DeviceId

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TeamViewerId

Optional return only the device that has the given TeamViewer Remote control Id.

```yaml
Type: Int32
Parameter Sets: FilteredList
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
