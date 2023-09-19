---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/Docs/Cmdlets_help/Add-TeamViewerManagedDevice.md
schema: 2.0.0
---

# Add-TeamViewerManagedDevice

## SYNOPSIS

Add a managed device to a managed group.

## SYNTAX

```powershell
Add-TeamViewerManagedDevice [-ApiToken] <SecureString> [-Device] <Object> [-Group] <Object> [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Adds an existing managed device to a managed group.
Offline devices will apply this change when coming online again.

## EXAMPLES

### Example 1

```powershell
PS /> Add-TeamViewerManagedDevice -Device 'c0cb303a-8a85-4e54-b657-a4757c791aef' -Group '9fd16af0-c224-4242-998e-a7138b038dbb'
```

Adds the managed device with the given device ID to the managed group with the
given group ID.

### Example 2

```powershell
PS /> $group = Get-TeamViewerManagedGroup -Id '9fd16af0-c224-4242-998e-a7138b038dbb'
PS /> $device = Get-TeamViewerManagedDevice -Id 'c0cb303a-8a85-4e54-b657-a4757c791aef'
PS /> Add-TeamViewerManagedDevice -Device $device -Group $group
```

Adds the managed device to the managed group using device/group objects that
have been received using other module functions.

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
Accept pipeline input: False
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

### None

## OUTPUTS

### None

## NOTES

## RELATED LINKS

[Get-TeamViewerManagedDevice](Get-TeamViewerManagedDevice.md)

[Get-TeamViewerManagedGroup](Get-TeamViewerManagedDevice.md)
