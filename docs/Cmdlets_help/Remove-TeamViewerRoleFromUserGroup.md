---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: 
schema: 2.0.0
---

# Remove-TeamViewerRoleFromAccount

## SYNOPSIS

Unassign user role from a user group.

## SYNTAX

```powershell
Remove-TeamViewerRoleFromAccount [-ApiToken] <SecureString> [-UserGroup] <Object> [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Unassigns user role from a user group of the TeamViewer company associated with the API access token.

## EXAMPLES

### Example 1

```powershell
PS /> Remove-TeamViewerRoleFromAccount -UserGroup 1001
```

The given user group `1001` gets unassigned from its user role.

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

The user group from which user role should be unassigned.

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
