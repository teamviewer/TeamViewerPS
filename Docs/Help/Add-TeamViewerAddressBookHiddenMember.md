---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/Docs/Help/Add-TeamViewerAddressBookHiddenMember.md
schema: 2.0.0
---

# Add-TeamViewerAddressBookHiddenMember

## SYNOPSIS

Hide members from the company address book.

## SYNTAX

```powershell
Add-TeamViewerAddressBookHiddenMember -APIToken <SecureString> -User <String[]> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Hides one or more accounts from the company address book. Hidden accounts will not appear in address book listings.

## EXAMPLES

### Example 1

```powershell
Add-TeamViewerAddressBookHiddenMember -APIToken $token -User 'user123'
```

Hide a single account from the address book.

### Example 2

```powershell
'user1', 'user2', 'user3' | Add-TeamViewerAddressBookHiddenMember -APIToken $token
```

Hide multiple accounts from the address book using pipeline input.

### Example 3

```powershell
$users = @('user1', 'user2', 'user3')
Add-TeamViewerAddressBookHiddenMember -APIToken $token -User $users
```

Hide multiple accounts from the address book using an array.

## PARAMETERS

### -User

The account ID(s) to hide from the address book.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: Id, UserId, Emailaddress

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -APIToken

The TeamViewer API access token.

```yaml
Type: SecureString
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
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

### System.String[]

Account IDs to hide from the address book.

## OUTPUTS

### System.Void

## NOTES

This cmdlet supports batching of up to 100 accounts per API request.
Accepts account IDs via the pipeline.

## RELATED LINKS

[Remove-TeamViewerAddressBookHiddenMember](Remove-TeamViewerAddressBookHiddenMember.md)
[Get-TeamViewerAddressBookHiddenMember](Get-TeamViewerAddressBookHiddenMember.md)
