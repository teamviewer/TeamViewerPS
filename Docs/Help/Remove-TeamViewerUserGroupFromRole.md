---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/Docs/Help/Remove-TeamViewerUserGroupFromRole.md
schema: 2.0.0
---

# Remove-TeamViewerUserGroupFromRole

## SYNOPSIS

Removes a user group from one specific role.

## SYNTAX

```powershell
Remove-TeamViewerUserGroupFromRole [-ApiToken] <SecureString> [-UserGroup] <Object> [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Removes a user group from one specific role of the TeamViewer company associated with the API access token.

## EXAMPLES

### Example 1

```powershell
Remove-TeamViewerUserGroupFromRole -UserGroup 1001
```

The given user group `1001` gets unassigned from the role.

### Example 2

```powershell
Remove-TeamViewerUserGroupFromRole -Id 1001
```

Uses the `Id` alias to unassign the user group `1001` from its role.

### Example 3

```powershell
Get-TeamViewerUserGroup -Name 'Support Team' | Remove-TeamViewerUserGroupFromRole
```

Removes the user group object retrieved via `Get-TeamViewerUserGroup` from its role.

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

### -UserGroup

The user group from which role should be unassigned.

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

## OUTPUTS

## NOTES

## RELATED LINKS
