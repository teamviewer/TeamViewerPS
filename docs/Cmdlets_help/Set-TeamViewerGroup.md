---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/Docs/Cmdlets_help/Set-TeamViewerGroup.md
schema: 2.0.0
---

# Set-TeamViewerGroup

## SYNOPSIS

Change a group in the Computers & Contacts list.

## SYNTAX

### ByParameters (Default)

```powershell
Set-TeamViewerGroup -ApiToken <SecureString> -Group <Object> [-Name <String>] [-Policy <Object>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

### ByProperties

```powershell
Set-TeamViewerGroup -ApiToken <SecureString> -Group <Object> -Property <Hashtable> [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION

Changes a group in the Computers & Contacts list.

## EXAMPLES

### Example 1

```powershell
PS /> Set-TeamViewerGroup -Group 'g1234' -Name 'New Group Name'
```

Change the name of the group with the given group ID.

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

### -Group

Object that can be used to identify the group.
This can either be the group ID or a group object that has been received using
other module functions.

```yaml
Type: Object
Parameter Sets: (All)
Aliases: Id, GroupId

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Name

The new name of the group.

```yaml
Type: String
Parameter Sets: ByParameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Policy

Change the policy assigned to the group and assign it to the given policy.

```yaml
Type: Object
Parameter Sets: ByParameters
Aliases: PolicyId

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Property

Change group information using a hashtable object.
Valid hashtable keys are: `name`, `policy_id`

```yaml
Type: Hashtable
Parameter Sets: ByProperties
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
