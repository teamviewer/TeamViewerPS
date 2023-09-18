---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/Docs/Cmdlets_help/Set-TeamViewerUserGroup.md
schema: 2.0.0
---

# Set-TeamViewerUserGroup

## SYNOPSIS

Update properties of a user group.

## SYNTAX

```powershell
Set-TeamViewerUserGroup [-ApiToken] <SecureString> [-UserGroup] <Object> [-Name] <String> [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION

Update properties of a user group. Currently it is only possible to rename a group.
New name should be unique among all user groups of the TeamViewer company.

## EXAMPLES

### Example 1

```powershell
PS /> Set-TeamViewerUserGroup -UserGroup 1001 -Name 'New name of the user group'
```

Renames a user group with id `1001` to `New name of the user group`.

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

### -Name

The new name of the group.

```yaml
Type: String
Parameter Sets: (All)
Aliases: UserGroupName

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -UserGroup

The user group to be updated.

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

### None

## OUTPUTS

### System.Object

A `TeamViewerPS.UserGroup` object.

## NOTES

## RELATED LINKS
