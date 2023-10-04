---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/Docs/Help/Publish-TeamViewerGroup.md
schema: 2.0.0
---

# Publish-TeamViewerGroup

## SYNOPSIS

Share a Computers & Contacts list group with other users.

## SYNTAX

```powershell
Publish-TeamViewerGroup [-ApiToken] <SecureString> [-Group] <Object> [-User] <Object[]>
 [[-Permissions] <Object>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Shares a Computers & Contacts list group with the given users.
It will not change the share-state of other users, but it is possible to
overwrite the permissions of existing shares.

## EXAMPLES

### Example 1

```powershell
PS /> Publish-TeamViewerGroup -Group 'g1234' -User 'u5678' 
```

Share the given group with the given user.

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

### -Group

Object that can be used to identify the group.
This can either be the group ID or a group object that has been received using
other module functions.

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

### -Permissions

Access permissions to give to the user on the group. Defaults to `read`.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:
Accepted values: read, readwrite

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -User

Object that can be used to identify the user.
This can either be the user ID or a user object that has been received using
other module functions.

```yaml
Type: Object[]
Parameter Sets: (All)
Aliases: UserId

Required: True
Position: 2
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

## NOTES

## RELATED LINKS
