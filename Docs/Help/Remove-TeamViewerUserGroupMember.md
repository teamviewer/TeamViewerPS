---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/Docs/Help/Remove-TeamViewerUserGroupMember.md
schema: 2.0.0
---

# Remove-TeamViewerUserGroupMember

## SYNOPSIS

Deletes members from a given user group.

## SYNTAX

### ByUserGroupMemberId (All)

```powershell
Remove-TeamViewerUserGroupMember [-ApiToken] <SecureString> [-UserGroup] <Object> [-UserGroupMember] <Object[]>
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

### ByUserId

```powershell
Remove-TeamViewerUserGroupMember [-ApiToken] <SecureString> [-UserGroup] <Object> [-User] <Object[]>
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Deletes one or many members from a user group. User group should belong to the TeamViewer company associated with the API access token.

## EXAMPLES

### Example 1

```powershell
PS /> Remove-TeamViewerUserGroupMember -UserGroup 1001 -UserGroupMember @(123, 456, 789)
```

Removes the accounts `123`, `456`, `789` from the group with id `1001`.

### Example 2

```powershell
PS /> @(123, 456, 789) | Remove-TeamViewerUserGroupMember -UserGroup 1001
```

Removes the accounts `123`, `456`, `789` from the group with id `1001`.
Ids are passed as pipeline input.

### Example 3

```powershell
PS /> Remove-TeamViewerUserGroupMember -UserGroup 1001 -User @('u123', 'u456', 'u789')
```

Removes the users `u123`, `u456`, `u789` from the group with id `1001`.

### Example 4

```powershell
PS /> Get-TeamViewerUserGroupMember -UserGroup 1001 | Remove-TeamViewerUserGroupMember -UserGroup 1001
```

Removes all the users from the group with id `1001`.
Ids are passed as pipeline input.

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

### -User

Users to be removed from a user group.

```yaml
Type: Object[]
Parameter Sets: ByUserId
Aliases: UserId

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -UserGroup

The group where members will be removed from.

```yaml
Type: Object
Parameter Sets: (All)
Aliases: Id, UserGroupId

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -UserGroupMember

User group members to be removed from a user group.

```yaml
Type: Object[]
Parameter Sets: (ByUserGroupMemberId)
Aliases: MemberId, UserGroupMemberId

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

### System.Int32[]

An array of account Ids.

## OUTPUTS

## NOTES

## RELATED LINKS
