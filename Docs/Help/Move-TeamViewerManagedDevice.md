---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/Docs/Help/Move-TeamViewerManagedDevice.md
schema: 2.0.0
---

# Move-TeamViewerManagedDevice

## SYNOPSIS

Move a managed device from one managed group to another.

## SYNTAX

```powershell
Move-TeamViewerManagedDevice [-ApiToken] <SecureString> [-Device] <Guid> [-SourceGroup] <Guid> [-TargetGroup] <Guid> [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Moves an existing managed device from one managed group to another.
This will remove the device from the source group, and add the device to the target group.
Offline devices will apply this change when coming online again.

## EXAMPLES

### Example

```powershell
PS /> Move-TeamViewerManagedDevice -Device 'c0cb303a-8a85-4e54-b657-a4757c791aef' -SourceGroup '9fd16af0-c224-4242-998e-a7138b038dbb' -TargetGroup '6084ffb1-c2d7-45e8-b6ab-5322ff761a30'
```

Moves the managed device with the given device ID from the managed group with the
given group ID to another managed group with the given group ID.

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

A string representing the management ID of the device.

```yaml
Type: Object
Parameter Sets: (All)
Aliases: DeviceId

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SourceGroup

A string representing the group ID of the source group.

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

### -TargetGroup

A string representing the group ID of the target group.

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

### None

## OUTPUTS

### None

## NOTES

## RELATED LINKS

[Get-TeamViewerManagedDevice](Get-TeamViewerManagedDevice.md)

[Get-TeamViewerManagedGroup](Get-TeamViewerManagedDevice.md)
