---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version:
schema: 2.0.0
---

# Set-TeamViewerDevice

## SYNOPSIS

Change a device entry in the Computers & Contacts list.

## SYNTAX

### Default (Default)

```powershell
Set-TeamViewerDevice -ApiToken <SecureString> -Device <Object> [-Name <String>] [-Description <String>]
 [-Password <SecureString>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### ChangeGroup

```powershell
Set-TeamViewerDevice -ApiToken <SecureString> -Device <Object> [-Group <Object>] [-Name <String>]
 [-Description <String>] [-Password <SecureString>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### ChangePolicy

```powershell
Set-TeamViewerDevice -ApiToken <SecureString> -Device <Object> [-Policy <Object>] [-Name <String>]
 [-Description <String>] [-Password <SecureString>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Changes an existing device entry in the Computers & Contacts list.

## EXAMPLES

### Example 1

```powershell
PS /> Set-TeamViewerDevice -DeviceId 'd1234' -Name 'My Updated Device Alias'
```

Change the device entry alias in the Computers & Contacts list.

### Example 2

```powershell
PS /> Set-TeamViewerDevice -DeviceId 'd1234' -GroupId 'g5678'
```

Move the device entry to a different group in the Computers & Contacts list.

### Example 3

```powershell
PS /> Set-TeamViewerDevice -DeviceId 'd1234' -Policy 'inherit'
```

Set the policy of the device entry to inherit from group.

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

### -Description

Optional descriptive text for the device entry.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Device

Object that can be used to identify the device entry.
This can either be the device ID or a device object that has been received
using other module functions.

```yaml
Type: Object
Parameter Sets: (All)
Aliases: Id, DeviceId

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Group

Object that can be used to identify the group.
This can either be the group ID or a group object that has been received using
other module functions.

Cannot be used in conjunction with the `-Policy` parameter.

```yaml
Type: Object
Parameter Sets: ChangeGroup
Aliases: GroupId

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name

Optional alias of the device in the Computers & Contacts list of this account.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Alias

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Password

Optional password that will be used when connecting to the device with the
TeamViewer desktop client.

```yaml
Type: SecureString
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Policy

Object that can be used to identify the policy.
This can either be the policy ID (as string or GUID) or a policy object that has
been received using other module functions.

Cannot be used in conjunction with the `-Group` parameter.

```yaml
Type: Object
Parameter Sets: ChangePolicy
Aliases: PolicyId

Required: False
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

## OUTPUTS

## NOTES

## RELATED LINKS
