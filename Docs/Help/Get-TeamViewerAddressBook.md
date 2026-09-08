---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/Docs/Help/Get-TeamViewerAddressBook.md
schema: 2.0.0
---

# Get-TeamViewerAddressBook

## SYNOPSIS

Get company address book settings and members.

## SYNTAX

```powershell
Get-TeamViewerAddressBook -APIToken <SecureString> [<CommonParameters>]
```

## DESCRIPTION

Retrieves the company address book settings and members list for the TeamViewer company associated with the API access token.

## EXAMPLES

### Example 1

```powershell
Get-TeamViewerAddressBook -APIToken $token
```

Get the address book for the TeamViewer company.

### Example 2

```powershell
$token | Get-TeamViewerAddressBook
```

Get the address book using the API token from the pipeline.

## PARAMETERS

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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### TeamViewerPS.AddressBook

Address book data including the `Enabled` setting and `Users` collection. The original API properties `companyAddressBookSettings` and `users` are also preserved.

Users are returned as `TeamViewerPS.AddressBookUser` objects with `UserId`, `AccountId`, `Name`, and `Email` properties.

## NOTES

This cmdlet automatically handles pagination and retrieves all available address book data.

## RELATED LINKS

[Set-TeamViewerAddressBook](Set-TeamViewerAddressBook.md)
[Get-TeamViewerAddressBookHiddenMember](Get-TeamViewerAddressBookHiddenMember.md)
