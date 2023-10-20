---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/Docs/Help/Get-TeamViewerUserGroupByRole.md
schema: 2.0.0
---

# Get-TeamViewerUserGroupByRole

## SYNOPSIS

Lists all user group assignments of a user role.

## SYNTAX

```powershell
Get-TeamViewerUserGroupByRole [-ApiToken] <SecureString> [-RoleId] <Object> [<CommonParameters>]
```

## DESCRIPTION

Lists all user groups of role in the TeamViewer company associated with the API access token.

## EXAMPLES

### Example 1

```powershell
PS /> Get-TeamViewerUserGroupByRole -RoleId '72abbedc-9853-4fc8-9d28-fa35e207b048'
```

Lists all user groups of the role `72abbedc-9853-4fc8-9d28-fa35e207b048`.

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

### -RoleId

Role to list its assigned users.

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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object

An array of `TeamViewerPS.RoleAssignedUserGroup` objects.

## NOTES

## RELATED LINKS
