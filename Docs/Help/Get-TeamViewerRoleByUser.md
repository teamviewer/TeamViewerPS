---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/Docs/Help/Get-TeamViewerUserByRole.md
schema: 2.0.0
---

# Get-TeamViewerRoleByUser

## SYNOPSIS

Returns the assigned role id of the user or null.

## SYNTAX

```powershell
Get-TeamViewerRoleByUser [-ApiToken] <SecureString> [-UserId] <Object> [<CommonParameters>]
```

## DESCRIPTION

Lists the assigned role of a user in the TeamViewer company associated with the API access token. If no role is assigned or user id is unknown, null is returned.

## EXAMPLES

### Example 1

```powershell
PS /> Get-TeamViewerRoleByUser -UserId "u123456777"
```

Lists the assigned role of the user with the ID u123456777.

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

### -UserId

User to list its assigned role.

```yaml
Type: Object
Parameter Sets: (All)
Aliases: UsersId

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

An array of `TeamViewerPS.UserAssignedRole` objects.

## NOTES

## RELATED LINKS
