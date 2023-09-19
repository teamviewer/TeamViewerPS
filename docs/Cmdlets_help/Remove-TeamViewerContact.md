---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/Docs/Cmdlets_help/Remove-TeamViewerContact.md
schema: 2.0.0
---

# Remove-TeamViewerContact

## SYNOPSIS

Delete a contact from the Computers & Contacts list.

## SYNTAX

```powershell
Remove-TeamViewerContact [-ApiToken] <SecureString> [-Contact] <Object> [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION

Deletes a contact from the Computers & Contacts list of the account associated
to the API access token.

## EXAMPLES

### Example 1

```powershell
PS /> Remove-TeamViewerContact -Contact 'c1234'
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

### -Contact

Object that can be used to identify the contact.
This can either be the contact ID or a contact object that has been received
using other module functions.

```yaml
Type: Object
Parameter Sets: (All)
Aliases: Id, ContactId

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
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

### System.Object

## OUTPUTS

## NOTES

## RELATED LINKS
