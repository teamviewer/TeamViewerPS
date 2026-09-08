---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/Docs/Help/Get-TeamViewerAddressBookHiddenMember.md
schema: 2.0.0
---

# Get-TeamViewerAddressBookHiddenMember

## SYNOPSIS

Get hidden members from the company address book.

## SYNTAX

```powershell
Get-TeamViewerAddressBookHiddenMember -APIToken <SecureString> [<CommonParameters>]
```

## DESCRIPTION

Retrieves the list of accounts that have been hidden from the company address book.

## EXAMPLES

### Example 1

```powershell
Get-TeamViewerAddressBookHiddenMember -APIToken $token
```

Get all hidden members from the address book.

### Example 2

```powershell
$hiddenAccounts = Get-TeamViewerAddressBookHiddenMember -APIToken $token
$hiddenAccounts | ForEach-Object { Write-Host "Hidden: $_" }
```

Get all hidden members and display them.

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

### System.String[]

Account IDs of hidden members.

## NOTES

This cmdlet automatically handles pagination and retrieves all hidden members.

## RELATED LINKS

[Add-TeamViewerAddressBookHiddenMember](Add-TeamViewerAddressBookHiddenMember.md)
[Remove-TeamViewerAddressBookHiddenMember](Remove-TeamViewerAddressBookHiddenMember.md)
[Get-TeamViewerAddressBook](Get-TeamViewerAddressBook.md)
