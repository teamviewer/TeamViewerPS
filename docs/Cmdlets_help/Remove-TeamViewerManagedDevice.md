---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/docs/Cmdlets_help/Remove-TeamViewerManagedDevice.md
schema: 2.0.0
---

# Remove-TeamViewerManagedDevice

## SYNOPSIS

Remove a managed device from a managed group.

## SYNTAX

```powershell
Remove-TeamViewerManagedDevice [-ApiToken] <SecureString> [-Device] <Object> [[-Group] <Object>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Removes a managed device from a managed group. The device remains in the
pending status "leave" until it gets online and actually leaves the managed
group. The current account needs `DeviceAdministration` manager permissions on
the device. 

## EXAMPLES

### Example 1

```powershell
PS /> Remove-TeamViewerManagedDevice -Device 'c0cb303a-8a85-4e54-b657-a4757c791aef' -Group '9fd16af0-c224-4242-998e-a7138b038dbb'
```

## PARAMETERS

### -ApiToken

The TeamViewer API access token.

```yaml
Type: SecureString
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
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
Parameter Sets: (All)
Aliases: DeviceId

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Group

Object that can be used to identify the managed group.
This can either be the managed group ID (as string or GUID) or a managed group
object that has been received using other module functions.

```yaml
Type: Object
Parameter Sets: (All)
Aliases: GroupId

Required: True
Position: 2
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
