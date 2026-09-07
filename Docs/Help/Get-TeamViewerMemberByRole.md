---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/Docs/Help/Get-TeamViewerMemberByRole.md
schema: 2.0.0
---

# Get-TeamViewerMemberByRole

## SYNOPSIS

Lists direct and indirect members of one role.

## SYNTAX

```powershell
Get-TeamViewerMemberByRole [-APIToken] <SecureString> [-Role] <Object> [<CommonParameters>]
```

## DESCRIPTION

Lists users and user groups that are direct members of the role, and users that are indirect members through a role member user group. A separate object is returned for each relationship.

## EXAMPLES

### Example 1

```powershell
Get-TeamViewerMemberByRole -Role '72abbedc-9853-4fc8-9d28-fa35e207b048'
```

Lists direct users, direct user groups, and indirect users for the role.

### Example 2

```powershell
Get-TeamViewerMemberByRole -Role '72abbedc-9853-4fc8-9d28-fa35e207b048' |
    Where-Object MembershipType -eq 'Indirect'
```

Lists users whose membership is inherited through a user group.

## PARAMETERS

### -APIToken

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

### -Role

The role whose members should be listed.

```yaml
Type: Object
Parameter Sets: (All)
Aliases: Id, RoleId

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

### TeamViewerPS.RoleMember

Objects with `RoleId`, `MemberType`, `MemberId`, `MembershipType`, and `Via_UserGroupId` properties. `MembershipType` is `Direct` or `Indirect`; `Via_UserGroupId` is populated for indirect users.

## NOTES

## RELATED LINKS
