---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/docs/Cmdlets_help/Get-TeamViewerContact.md
schema: 2.0.0
---

# Get-TeamViewerContact

## SYNOPSIS

Returns the contacts of the current account's Computers & Contacts list.

## SYNTAX

### FilteredList (Default)

```powershell
Get-TeamViewerContact -ApiToken <SecureString> [-Name <String>] [-FilterOnlineState <String>] [-Group <Object>]
 [<CommonParameters>]
```

### ByContactId

```powershell
Get-TeamViewerContact -ApiToken <SecureString> [-Id <String>] [<CommonParameters>]
```

## DESCRIPTION

Returns a list of contacts in the user’s Computers & Contacts list that match
the criteria given in the parameters.

## EXAMPLES

### Example 1

```powershell
PS /> Get-TeamViewerContact
```

List all contacts of the account associated to the TeamViewer API access token.

### Example 2

```powershell
PS /> Get-TeamViewerContact -Id 'c1234'
```

Gets the contact entry with the given ID.

### Example 3

```powershell
PS /> Get-TeamViewerContact -Name 'test' -FilterOnlineState 'Away'
```

List all contacts of the account associated to the TeamViewer API access token
that contain the string `test` in their name and are in the `Away` online state.

## PARAMETERS

### -ApiToken

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

### -FilterOnlineState

Optional filter for contacts in a certain online state.

```yaml
Type: String
Parameter Sets: FilteredList
Aliases:
Accepted values: Online, Busy, Away, Offline

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
If given, the command only returns contacts that are part of that group.

```yaml
Type: Object
Parameter Sets: FilteredList
Aliases: GroupId

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Id

Contact identifier used to get only a single specific contact list entry.

```yaml
Type: String
Parameter Sets: ByContactId
Aliases: ContactId

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name

Optional filter that can be used to retrieve only those contact list entries
that have the given string contained in their name.

```yaml
Type: String
Parameter Sets: FilteredList
Aliases: PartialName

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
