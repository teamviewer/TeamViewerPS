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
Get-TeamViewerDevice -ApiToken <SecureString> [-TeamViewerId <Int32>] [-FilterOnlineState <String>]
 [-Group <Object>] [<CommonParameters>]
```

### ByDeviceId

```powershell
Get-TeamViewerDevice -ApiToken <SecureString> [-Id <String>] [<CommonParameters>]
```

## DESCRIPTION

Returns a list of contacts in the user's Computers & Contacts list that match
the criteria given in the parameters.

## EXAMPLES

### Example 1

```powershell
PS /> Get-TeamViewerDevice
```

List all devices of the Computers & Contacts list.

### Example 2

```powershell
PS /> Get-TeamViewerDevice -Id 'd1234'
```

Get the device entry with the given ID.

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

### -FilterOnlineState

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
This can either be the group ID or a group object that has been received using
other module functions.
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

### -Id

Device identifier used to get only a single specific device list entry.

```yaml
Type: String
Parameter Sets: ByDeviceId
Aliases: DeviceId

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TeamViewerId

Optional return only the device that has the given TeamViewer Remote control ID.

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
