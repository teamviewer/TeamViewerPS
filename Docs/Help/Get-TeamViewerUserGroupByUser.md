---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/Docs/Help/Get-TeamViewerUserGroupByUser.md
schema: 2.0.0
---

# Get-TeamViewerUserGroupByUser

## SYNOPSIS

Lists the user groups a user is a member of.

## SYNTAX

```powershell
Get-TeamViewerUserGroupByUser [-APIToken] <SecureString> [-User] <Object> [<CommonParameters>]
```

## DESCRIPTION

Lists the user groups of the TeamViewer company associated with the API access token that the specified user is a member of.

## EXAMPLES

### Example 1

```powershell
Get-TeamViewerUserGroupByUser -UserId 'u123456777'
```

Lists the user groups of the user with Id `u123456777`.

### Example 2

```powershell
$user = Get-TeamViewerUser -UserId 'u123456777'
Get-TeamViewerUserGroupByUser -User $user
```

Lists the user groups by passing a `TeamViewerPS.User` object.

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

### -User

The user whose user group memberships are returned. Accepts a user Id or a `TeamViewerPS.User` object.

```yaml
Type: Object
Parameter Sets: (All)
Aliases: Id, UserId

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

### TeamViewerPS.UserGroup

An array of `TeamViewerPS.UserGroup` objects with `Id` and `Name` properties.

## NOTES

## RELATED LINKS
