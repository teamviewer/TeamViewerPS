---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/Docs/Help/Get-TeamViewerUserGroupByRole.md
schema: 2.0.0
---

# Get-TeamViewerRoleByUserGroup

## SYNOPSIS

Returns the assigned role id of the user group or null.

## SYNTAX

```powershell
Get-TeamViewerRoleByUserGroup [-ApiToken] <SecureString> [-GroupId] <Object> [<CommonParameters>]
```

## DESCRIPTION

Lists the assigned role of a user group in the TeamViewer company associated with the API access token. If no role is assigned or user group id is unknown, null is returned.

## EXAMPLES

### Example 1

```powershell
PS /> Get-TeamViewerRoleByUserGroup -GroupId "12345"
```

Lists the assigned role of the user group with the ID 12345.

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

### -GroupId

Group to list its assigned role.

```yaml
Type: Object
Parameter Sets: (All)
Aliases: GroupId

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

An array of `TeamViewerPS.UserGroupAssignedRole` objects.

## NOTES

## RELATED LINKS
