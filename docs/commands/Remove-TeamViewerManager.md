---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/docs/commands/Remove-TeamViewerManager.md
schema: 2.0.0
---

# Remove-TeamViewerManager

## SYNOPSIS

Remove managers from a managed group or a managed device.

## SYNTAX

### ByDeviceId (Default)

```powershell
Remove-TeamViewerManager -ApiToken <SecureString> -Manager <Object> [-Device <Object>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### ByGroupId

```powershell
Remove-TeamViewerManager -ApiToken <SecureString> -Manager <Object> [-Group <Object>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION

Removes a manager from a managed group or a managed device.
The current manager requires `ManagerAdministration` manager permissions.

It is not possible to remove the last manager with `ManagerAdministration` from
a managed group or managed device. At least one manager must remain with that
permission.

## EXAMPLES

### Example 1

```powershell
PS /> Remove-TeamViewerManager -Device 'c0cb303a-8a85-4e54-b657-a4757c791aef' -Manager '57e8f75e-8e6f-4450-a59d-10e02ccf5986'
```

Remove the given manager from the given managed device.

### Example 2

```powershell
PS /> Remove-TeamViewerManager -Group '9fd16af0-c224-4242-998e-a7138b038dbb' -Manager '57e8f75e-8e6f-4450-a59d-10e02ccf5986'
```

Remove the given manager from the given managed group.

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
Parameter Sets: ByDeviceId
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
Parameter Sets: ByGroupId
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
