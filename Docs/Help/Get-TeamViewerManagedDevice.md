---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/Docs/Help/Get-TeamViewerManagedDevice.md
schema: 2.0.0
---

# Get-TeamViewerManagedDevice

## SYNOPSIS

Retrieves TeamViewer managed devices.

## SYNTAX

### List (Default)

```powershell
Get-TeamViewerManagedDevice -ApiToken <SecureString> [<CommonParameters>]
```

### ByDeviceId

```powershell
Get-TeamViewerManagedDevice -ApiToken <SecureString> [-Id <Guid>] [<CommonParameters>]
```

### ListGroup

```powershell
Get-TeamViewerManagedDevice -ApiToken <SecureString> -Group <Object> [-Pending] [<CommonParameters>]
```

## DESCRIPTION

Retrieves managed devices of the manager that is associated with the API access
token. This can either be devices where this manager was added directly or
optionally devices of a managed group.

## EXAMPLES

### Example 1

```powershell

PS /> Get-TeamViewerManagedDevice
```

List all directly managed devices of this manager.

### Example 2

```powershell

PS /> Get-TeamViewerManagedDevice -Group '9fd16af0-c224-4242-998e-a7138b038dbb'
```

List all managed devices of the given group. This manager needs to be part of
the group.

### Example 3

```powershell

PS /> Get-TeamViewerManagedDevice -Id 'c0cb303a-8a85-4e54-b657-a4757c791aef'
```

Retrieve a single managed device entry for the device with the given ID.

### Example 4

```powershell
PS /> Get-TeamViewerManagedDevice -Id (Get-TeamViewerManagementId)
```

Retrieve information about the management state of the current device.

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

### -Group

Object that can be used to identify a managed group.
This can either be the managed group ID (as string or GUID) or a managed group
object that has been received using other module functions.

If given, the command returns managed devices of that group.

```yaml
Type: Object
Parameter Sets: ListGroup
Aliases: GroupId

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Id

Optional managed device ID. If given, the command retrieves a single managed
device entry with this device ID.

```yaml
Type: Guid
Parameter Sets: ByDeviceId
Aliases: DeviceId

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Pending

If given, the command will retrieve the list of pending device entries for a
given managed group. Such pending devices will either join or leave the group
as soon as they apply the outstanding changes (e.g. when the devices come
online again).

The pending operation is indicated by the `PendingOperation` object member. 

```yaml
Type: SwitchParameter
Parameter Sets: ListGroup
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

### None

## OUTPUTS

## NOTES

## RELATED LINKS

[Get-TeamViewerManagedGroup](Get-TeamViewerManagedGroup.md)

[Get-TeamViewerManagementId](Get-TeamViewerManagementId.md)
