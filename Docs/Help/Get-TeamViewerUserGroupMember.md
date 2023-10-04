---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/Docs/Help/Get-TeamViewerUserGroupMember.md
schema: 2.0.0
---

# Get-TeamViewerUserGroupMember

## SYNOPSIS

List all members of a user group.

## SYNTAX

```powershell
Get-TeamViewerUserGroupMember [-ApiToken] <SecureString> [-UserGroup] <Object> [<CommonParameters>]
```

## DESCRIPTION

Lists all members of a user group of the TeamViewer company associated with the API access token.

## EXAMPLES

### Example 1

```powershell
PS /> Get-TeamViewerUserGroupMember -Id 1001
```

List members all members of the user group with Id 1001.

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

### -UserGroup

UserGroup to list its members.

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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object

An array of `TeamViewerPS.UserGroupMember` objects.

## NOTES

## RELATED LINKS
