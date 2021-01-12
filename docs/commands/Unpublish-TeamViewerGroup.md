---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/docs/commands/Unpublish-TeamViewerGroup.md
schema: 2.0.0
---

# Unpublish-TeamViewerGroup

## SYNOPSIS

Unshare a Computers & Contacts list group.

## SYNTAX

```powershell
Unpublish-TeamViewerGroup [-ApiToken] <SecureString> [-Group] <Object> [-User] <Object[]> [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION

Removes existing share of a Computers & Contacts list group for given users.

## EXAMPLES

### Example 1

```powershell
PS C:\> Unpublish-TeamViewerGroup -Group 'g1234' -User 'u5678'
```

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
