---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/Docs/Help/Add-TeamViewerUserGroupToRole.md
schema: 2.0.0
---

# Add-TeamViewerUserGroupToRole

## SYNOPSIS

Assign a user group to a role.

## SYNTAX

```powershell
Add-TeamViewerUserGroupToRole [-ApiToken] <SecureString> [-Role] <Object> [-UserGroup] <Object> [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Assigns a user group to a role of the TeamViewer company associated with the API access token.

## EXAMPLES

### Example 1

```powershell
PS /> Add-TeamViewerUserGroupToRole -Role  '9b465ea2-2f75-4101-a057-58a81ed0e57b' -UserGroup 1001
```

The given user group `1001` gets assigned to the role with Id `9b465ea2-2f75-4101-a057-58a81ed0e57b`.

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

### -Role

The role to be assigned to the accountIds

```yaml
Type: Object
Parameter Sets: (All)
Aliases: Role

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -UserGroup

The user group to which the role should be assigned.

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
