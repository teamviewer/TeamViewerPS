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
Add-TeamViewerAddressBookHiddenMember -APIToken <SecureString> -User <Object[]> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Hides one or more accounts from the company address book. Hidden accounts will not appear in address book listings.
Account identifiers are sent as a JSON array of unsigned 32-bit numbers, as required by the API.
Accepts numeric account IDs, prefixed user IDs, email addresses, and `TeamViewerPS.User` objects.
Email addresses are resolved using `Get-TeamViewerUser` and require permission to list users.

## EXAMPLES

### Example 1

```powershell
Add-TeamViewerAddressBookHiddenMember -APIToken $token -User 303950
```

Hide a single account from the address book.

### Example 2

```powershell
303950, 303951, 303952 | Add-TeamViewerAddressBookHiddenMember -APIToken $token
```

Hide multiple accounts from the address book using pipeline input.

### Example 3

```powershell
$users = @(303950, 303951, 303952)
Add-TeamViewerAddressBookHiddenMember -APIToken $token -User $users
```

Hide multiple accounts from the address book using an array.

### Example 4

```powershell
Add-TeamViewerAddressBookHiddenMember -APIToken $token -Email 'user@example.com'
```

Resolve an email address and hide the matching account.

### Example 5

```powershell
Get-TeamViewerUser -APIToken $token -Email 'user@example.com' |
 Add-TeamViewerAddressBookHiddenMember -APIToken $token
```

Hide user objects received through the pipeline without an additional user lookup.

## PARAMETERS

### -User

The account(s) to hide from the address book. Accepts numeric account IDs in the range 0 through 4294967295,
numeric strings, prefixed user IDs (such as `u303950`), email addresses, or `TeamViewerPS.User` objects.
Input forms may be mixed in an array. User objects supply their `Id` without another lookup.
Email lookup requires exactly one case-insensitive exact address match; missing or ambiguous matches raise an error.
Repeated email addresses are looked up only once per invocation.

```yaml
Type: Object[]
Parameter Sets: (All)
Aliases: Id, UserId, Email, Emailaddress

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

### System.Object[]

Account IDs, prefixed user IDs, email addresses, or `TeamViewerPS.User` objects to hide from the address book.

## OUTPUTS

### System.Void

## NOTES

This cmdlet supports batching of up to 100 accounts per API request.
Accepts accounts via the pipeline or an array, including arrays larger than 100 entries.
With `-WhatIf`, no email lookups or mutation requests are performed.

## RELATED LINKS

[Remove-TeamViewerAddressBookHiddenMember](Remove-TeamViewerAddressBookHiddenMember.md)
[Get-TeamViewerAddressBookHiddenMember](Get-TeamViewerAddressBookHiddenMember.md)
