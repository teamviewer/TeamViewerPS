---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/docs/commands/Set-TeamViewerManagedDevice.md
schema: 2.0.0
---

# Set-TeamViewerManagedDevice

## SYNOPSIS

Change properties of a TeamViewer managed device.

## SYNTAX

```powershell
Set-TeamViewerManagedDevice [-ApiToken] <SecureString> [-Device] <Object> [[-Name] <String>]
 [[-Policy] <Object>] [-RemovePolicy] [[-ManagedGroup] <Object>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Changes properties of a managed device. For example, the name of the managed
device or the policy can be changed.

For changing the device name, the current account needs `DeviceAdministration`
manager permissions on the device.

For changing the device's policy, the current account needs
`PolicyAdministration` manager permissions on the device.

## EXAMPLES

### Example 1

```powershell
PS /> Set-TeamViewerManagedDevice -Device '33a2e2e1-27ef-43e2-a175-f97ee0344033' -Name 'My Device'
```

Changes the device alias.

### Example 2

```powershell
PS /> Set-TeamViewerManagedDevice -Device '33a2e2e1-27ef-43e2-a175-f97ee0344033' -Policy '63351a3e-3077-41ae-9f66-b38a61965485'
```

Sets the policy of the device.

### Example 3

```powershell
PS /> Set-TeamViewerManagedDevice -Device '33a2e2e1-27ef-43e2-a175-f97ee0344033' -RemovePolicy
```

Removes the TeamViewer policy of the device.

### Example 3

```powershell
PS /> Set-TeamViewerManagedDevice -Device '33a2e2e1-27ef-43e2-a175-f97ee0344033' -ManagedGroup '730ee15a-1ea4-4d80-9cfe-5a01709d0a2f'
```

Inherit the TeamViewer policy from a managed group to the device (the device has to be part of the managed group specified).

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

### -Name

New alias for the managed device.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Alias

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Policy

Object that can be used to identify the policy.
This can either be the policy ID (as string or GUID) or a policy object that has
been received using other module functions.

Cannot be used in conjunction with the `-RemovePolicy` parameter.

```yaml
Type: Object
Parameter Sets: (All)
Aliases: PolicyId

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RemovePolicy

Removes the policy from the managed device.

Cannot be used in conjunction with the `-Policy` parameter.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ManagedGroup

Object that can be used to identify the managed group.
This can either be the managed group ID (as string or GUID) or a managed group
object that has been received using other module functions.

```yaml
Type: Object
Parameter Sets: (All)
Aliases: ManagedGroupId

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
