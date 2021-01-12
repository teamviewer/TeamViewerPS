---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version:
schema: 2.0.0
---

# Set-TeamViewerManager

## SYNOPSIS

Change permissions of a managed group manager or managed device manager.

## SYNTAX

### Device_ByParameters (Default)

```powershell
Set-TeamViewerManager -ApiToken <SecureString> -Manager <Object> [-Device <Object>] [-Permissions <String[]>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Device_ByProperties

```powershell
Set-TeamViewerManager -ApiToken <SecureString> -Manager <Object> [-Device <Object>] -Property <Hashtable>
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Group_ByProperties

```powershell
Set-TeamViewerManager -ApiToken <SecureString> -Manager <Object> [-Group <Object>] -Property <Hashtable>
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Group_ByParameters

```powershell
Set-TeamViewerManager -ApiToken <SecureString> -Manager <Object> [-Group <Object>] [-Permissions <String[]>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Changes permissions of a managed group manager or managed device manager.

It is not possible to take away the `ManagerAdministration` permissions from
all managers of a managed group or managed device. At least one manager must
remain with that permission.

## EXAMPLES

### Example 1

```powershell
PS /> Set-TeamViewerManager -Device 'c0cb303a-8a85-4e54-b657-a4757c791aef' -Manager '57e8f75e-8e6f-4450-a59d-10e02ccf5986' -Permissions 'EasyAccess', 'ManagerAdministration'
```

Change the permissions of the given manager on the managed device with the given
ID.

### Example 2

```powershell
PS /> Set-TeamViewerManager -Group '9fd16af0-c224-4242-998e-a7138b038dbb' -Manager '57e8f75e-8e6f-4450-a59d-10e02ccf5986' -Permissions 'EasyAccess', 'ManagerAdministration'
```

Change the permissions of the given manager on the managed group with the given
ID.

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
Parameter Sets: Device_ByParameters, Device_ByProperties
Aliases: DeviceId

Required: False
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
Parameter Sets: Group_ByProperties, Group_ByParameters
Aliases: GroupId

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Manager

Object that can be used to identify the manager.
This can either be the manager ID (as string or GUID) or a manager object that
has been received using other module functions.

```yaml
Type: Object
Parameter Sets: (All)
Aliases: Id, ManagerId

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Permissions

Permissions to give to the manager.
An empty set of permissions still allows read-only access on the device/group
data. Multiple values can be specified.

`ManagerAdministration` allows the manager to change other managers on the given
device or group.

`DeviceAdministration` (only for managed devices) allows the manager to change
device-specific properties, e.g. the device name. Also reqruied to add devices
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
Parameter Sets: Device_ByParameters, Group_ByParameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Property

Change manager information using a hashtable object.
Valid hashtable keys are: `permissions`

```yaml
Type: Hashtable
Parameter Sets: Device_ByProperties, Group_ByProperties
Aliases:

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

### System.Object

## OUTPUTS

## NOTES

## RELATED LINKS
