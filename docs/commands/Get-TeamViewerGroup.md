---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version:
schema: 2.0.0
---

# Get-TeamViewerGroup

## SYNOPSIS

Returns TeamViewer groups.

## SYNTAX

### FilteredList (Default)

```powershell
Get-TeamViewerGroup -ApiToken <SecureString> [-Name <String>] [-FilterShared <String>] [<CommonParameters>]
```

### ByGroupId

```powershell
Get-TeamViewerGroup -ApiToken <SecureString> [-Id <String>] [<CommonParameters>]
```

## DESCRIPTION

Returns either a list of TeamViewer groups or a single TeamViewer group entry
that are associated to the current account (API access token).

## EXAMPLES

### Example 1

```powershell
PS /> Get-TeamViewerGroup
```

List all TeamViewer groups of the current account.

### Example 2

```powershell
PS /> Get-TeamViewerGroup -Id 'g1234'
```

Get a single TeamViewer group entry with the given ID.

### Example 3

```powershell
PS /> Get-TeamViewerGroup -Name 'test'
```

List all TeamViewer groups of the current account that have the string `test` in
their group name.

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

### -FilterShared

Optional filter parameter to return either only groups that are shared or not
shared.

```yaml
Type: String
Parameter Sets: FilteredList
Aliases:
Accepted values: OnlyShared, OnlyNotShared

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Id

Group identifier used to get only a single specific group entry.

```yaml
Type: String
Parameter Sets: ByGroupId
Aliases: GroupId

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name

Optional name filter parameter that can be used to only list groups that have
the given string in their name.

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
