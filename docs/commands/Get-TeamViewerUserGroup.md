---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/docs/commands/Get-Get-TeamViewerUserGroup.md
schema: 2.0.0
---

# Get-TeamViewerUserGroup

## SYNOPSIS

Retrieve user groups of a TeamViewer company.

## SYNTAX

```powershell
Get-TeamViewerUserGroup [-ApiToken] <SecureString> [[-UserGroup] <Object>] [<CommonParameters>]
```

## DESCRIPTION

Lists all user groups of the TeamViewer company associated with the API access token.
The list can optionally be filtered using additional parameters.

## EXAMPLES

### Example 1

```powershell
PS /> Get-TeamViewerUserGroup
```

List all user groups.

### Example 2

```powershell
PS /> Get-TeamViewerUserGroup -Id 1001
```

Retrieve a single user group with id 1001.

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

Optional UserGroup that can be used to only get information of a specific user group.

```yaml
Type: Object
Parameter Sets: (All)
Aliases: Id, UserGroupId

Required: False
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

An array of `TeamViewerPS.UserGroup` objects.

## NOTES

## RELATED LINKS
