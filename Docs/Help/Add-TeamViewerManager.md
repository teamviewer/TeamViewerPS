---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/Docs/Help/Add-TeamViewerManager.md
schema: 2.0.0
---

# Add-TeamViewerManager

## SYNOPSIS

Add a manager to a managed device or managed group.

## SYNTAX

### Device_ByAccountId (Default)

```
Add-TeamViewerManager -ApiToken <SecureString> -AccountId <String> -Device <Object> [-Permissions <String[]>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Group_ByAccountId

```
Add-TeamViewerManager -ApiToken <SecureString> -AccountId <String> -Group <Object> [-Permissions <String[]>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Group_ByManagerId

```
Add-TeamViewerManager -ApiToken <SecureString> -Manager <Object> -Group <Object> [-Permissions <String[]>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Device_ByManagerId

```
Add-TeamViewerManager -ApiToken <SecureString> -Manager <Object> -Device <Object> [-Permissions <String[]>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Group_ByUserObject

```
Add-TeamViewerManager -ApiToken <SecureString> -User <Object> -Group <Object> [-Permissions <String[]>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Device_ByUserObject

```
Add-TeamViewerManager -ApiToken <SecureString> -User <Object> -Device <Object> [-Permissions <String[]>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Device_ByUserGroupId

```
Add-TeamViewerManager -ApiToken <SecureString> -UserGroup <Object> -Device <Object> [-Permissions <String[]>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Group_ByUserGroupId

```
Add-TeamViewerManager -ApiToken <SecureString> -UserGroup <Object> -Group <Object> [-Permissions <String[]>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Adds a manager to a managed device or a managed group. Managers can either be
identified by a TeamViewer account ID or their manager ID.
The current account (identified by the API access token) needs
`ManagerAdministration` manager permissions on the device/group.

## EXAMPLES

### Example 1

```powershell
PS /> Add-TeamViewerManager -Device 'c0cb303a-8a85-4e54-b657-a4757c791aef' -Manager '57e8f75e-8e6f-4450-a59d-10e02ccf5986'
```

Add the manager with the given Manager ID to the managed device with the given
device ID.

### Example 2

```powershell
PS /> Add-TeamViewerManager -Group '9fd16af0-c224-4242-998e-a7138b038dbb' -Manager '57e8f75e-8e6f-4450-a59d-10e02ccf5986'
```

Add the manager with the given Manager ID to the managed group with the given
group ID.

### Example 3

```powershell
PS /> Add-TeamViewerManager -Group '9fd16af0-c224-4242-998e-a7138b038dbb' -AccountId 1234
```

Add the manager with the given TeamViewer account ID to the managed group with
the given group ID.

## PARAMETERS

### -AccountId

TeamViewer account ID used to identify the manager to add.

```yaml
Type: String
Parameter Sets: Device_ByAccountId, Group_ByAccountId
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

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

### -Confirm

Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Device

Object that can be used to identify the managed device.
This can either be the managed device ID (as string or GUID) or a managed device
object that has been received using other module functions.

```yaml
Type: Object
Parameter Sets: Device_ByAccountId, Device_ByManagerId, Device_ByUserObject, Device_ByUserGroupId
Aliases: DeviceId

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Group

Object that can be used to identify the managed group.
This can either be the managed group ID (as string or GUID) or a managed group
object that has been received using other module functions.

```yaml
Type: Object
Parameter Sets: Group_ByAccountId, Group_ByManagerId, Group_ByUserObject, Group_ByUserGroupId
Aliases: GroupId

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Manager

Object that can be used to identify the manager to add.
This can either be the manager ID (as string or GUID) or a manager object that
has been received using other module function.

```yaml
Type: Object
Parameter Sets: Group_ByManagerId, Device_ByManagerId
Aliases: ManagerId

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Permissions

Optional permissions to give to the manager.
By default, the manager receives an empty set of permissions, which still allows
read-only access on the device/group data.
Multiple values can be specified.

`ManagerAdministration` allows the manager to change other managers on the given
device or group.

`DeviceAdministration` (only for managed devices) allows the manager to change
device-specific properties, e.g. the device name. Also required to add devices
to managed groups.

`GroupAdministration` (only for managed groups) allows the manager to change
group-specific properties, e.g. the group name. Also required to add managed
devices to the group.

`PolicyAdministration` (only for managed devices) allows the manager to change
the policy that has been assigned to the managed device.

`EasyAccess` allows the manager to connect to the device (or the devices of the
group) via "EasyAccess" (without additional password).

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -User

User object received by the `Get-TeamViewerUser` cmdlet. It can be used to
identify the manager that should be added to the device/group.

```yaml
Type: Object
Parameter Sets: Group_ByUserObject, Device_ByUserObject
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -UserGroup

UserGroup object as returned from `Get-TeamViewerUserGroup` or Id of the UserGroup which should be added as manager of the targeted managed group or managed device.

```yaml
Type: Object
Parameter Sets: Device_ByUserGroupId, Group_ByUserGroupId
Aliases: UserGroupId

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf

Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

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

[Get-TeamViewerManager](Get-TeamViewerManager.md)

[Get-TeamViewerManagedDevice](Get-TeamViewerManagedDevice.md)

[Get-TeamViewerManagedGroup](Get-TeamViewerManagedGroup.md)

[Get-TeamViewerUser](Get-TeamViewerUser.md)
