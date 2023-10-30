---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/Docs/Help/Set-TeamViewerManagedGroup.md
schema: 2.0.0
---

# Set-TeamViewerManagedGroup

## SYNOPSIS

Change properties of a TeamViewer managed group.

## SYNTAX

### ByParameters (Default)

```powershell
Set-TeamViewerManagedGroup -ApiToken <SecureString> -Group <Object> -Name <String> [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### ByProperties

```powershell
Set-TeamViewerManagedGroup -ApiToken <SecureString> -Group <Object> -Property <Hashtable> [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION

Changes properties of a managed group. For example, the name of the group can be
changed. The current account needs `GroupAdministration` manager permissions on
the group.

## EXAMPLES

### Example 1

```powershell
PS /> Set-TeamViewerManagedGroup -Group '9fd16af0-c224-4242-998e-a7138b038dbb' -Name 'My New Group'
```

Change the name of the managed group with the given ID.

### Example 2

```powershell
PS /> Set-TeamviewerManagedGroup -GroupId '6808db5b-f3c1-4e42-8168-3ac96f5d456e' -PolicyId '926d7a7e-b640-43a9-bc95-4f71ed7e6878' -PolicyType 4
```

Change the policy of the managed group with the given ID.

### Example 3

```powershell
PS /> Set-TeamViewerManagedGroup -GroupId '6808db5b-f3c1-4e42-8168-3ac96f5d456e' -Property {'policy_id' = 'e563798b-b988-4917-b1d3-a012ce6ba929' 'policy_type' = 1}
```

Change the policy of the managed group with the given ID using property parameters.

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

Object that can be used to identify the managed group.
This can either be the managed group ID (as string or GUID) or a managed group
object that has been received using other module functions.

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

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PolicyId

Change the policy assigned to the group and assign it the given policy.

```yaml
Type: Object
Parameter Sets: ByParameters
Aliases: Policy

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PolicyType

The type of policy to be set to the managed group.

```yaml
Type: PolicyType (Enum)
Parameter Sets: (All)
Aliases:
Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Property

Change managed group information using a hashtable object.
Valid hashtable keys are: `name`

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
