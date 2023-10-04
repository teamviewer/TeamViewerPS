---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/Docs/Help/Add-TeamViewerUserGroupMember.md
schema: 2.0.0
---

# Add-TeamViewerUserGroupMember

## SYNOPSIS

Add a list of accountIds to a user group.

## SYNTAX

```powershell
Add-TeamViewerUserGroupMember [-ApiToken] <SecureString> [-UserGroup] <Object> [-Member] <Int32[]> [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Adds a list of accountIds to a user groups of the TeamViewer company associated with the API access token.

## EXAMPLES

### Example 1

```powershell
PS /> Add-TeamViewerUserGroupMember -Id 1001 -Member @(123, 456, 789)
PS /> Add-TeamViewerUserGroupMember -Id 1001 -Member 123, 456, 789
```

Adds the given accountIds (123, 456, 789) to the user group with Id 1001.

### Example 2

```powershell
PS /> @(123, 456, 789) | Add-TeamViewerUserGroupMember -Id 1001
```

Adds the given accountIds (123, 456, 789) to the user group with Id 1001.
Ids are passed as pipeline input.

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

### -Member

The list of accounts Ids to be added as member of the group.

```yaml
Type: Int32[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -UserGroup

The groups where accounts will be added as members

```yaml
Type: Object
Parameter Sets: (All)
Aliases: Id, UserGroupId

Required: True
Position: 1
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

### System.Int32[]

An array of account Ids.

## OUTPUTS

### System.Object

An array of `TeamViewerPS.UserGroupMember` objects.

## NOTES

## RELATED LINKS
