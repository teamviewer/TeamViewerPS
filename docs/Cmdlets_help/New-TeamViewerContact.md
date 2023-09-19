---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/Docs/Cmdlets_help/New-TeamViewerContact.md
schema: 2.0.0
---

# New-TeamViewerContact

## SYNOPSIS

Create a new contact entry in the TeamViewer Computers & Contacts list.

## SYNTAX

```powershell
New-TeamViewerContact [-ApiToken] <SecureString> [-Email] <String> [-Group] <Object> [-Invite] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Adds a new contact to the Computers & Contacts list of the account that is
associated to the TeamViewer API access token. 

## EXAMPLES

### Example 1

```powershell
PS /> New-TeamViewerContact -Email 'test@example.test' -Group 'g1234'
```

Add the account with the given email address to the Computers & Contacts list
into the group with the given group ID.

### Example 2

```powershell
PS /> New-TeamViewerContact -Email 'another@example.test' -Group 'g1234' -Invite
```

Add a new entry to the Computers & Contacts list and send an invitation to the
given email address if no such user exists yet.

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

### -Email

Email address of the contact to add (or invite).

```yaml
Type: String
Parameter Sets: (All)
Aliases: EmailAddress

Required: True
Position: 1
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
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Invite

Creates an invitation if there is no account with the given email address.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
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

[Get-TeamViewerGroup](Get-TeamViewerGroup.md)
