---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/Docs/Help/Get-TeamViewerOrganizationalUnit.md
schema: 2.0.0
---

# Get-TeamViewerOrganizationalUnit

## SYNOPSIS

Returns TeamViewer organizational units.

## SYNTAX

### FilteredList (Default)

```powershell
Get-TeamViewerOrganizationalUnit -ApiToken <SecureString> [-Name <String>] [-Description <String>] [-Parent <String>] [<CommonParameters>]
```

### ByOrganizationalUnitId

```powershell
Get-TeamViewerOrganizationalUnit -ApiToken <SecureString> [-Id <String>] [<CommonParameters>]
```

## DESCRIPTION

Returns either a list of TeamViewer organizational units or a single TeamViewer organizational unit
that are associated to the current account (API access token) and TV company.

## EXAMPLES

### Example 1

```powershell
PS /> Get-TeamViewerOrganizationalUnit
```

List all TeamViewer organizational units that are associated to the current account and TV company.

### Example 2

```powershell
PS /> Get-TeamViewerOrganizationalUnit -Id '1cbae0b5-8a2f-487a-a8cf-5b884787b52c'
```

Get a single TeamViewer organizational unit with the given Id `1cbae0b5-8a2f-487a-a8cf-5b884787b52c`.

### Example 3

```powershell
PS /> Get-TeamViewerOrganizationalUnit -Name 'test'
```

List all TeamViewer organizational units of the current account and TV company that have the string `test` in their name.

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

### -Id

Organizational unit identifier used to get only a single specific organizational unit.

```yaml
Type: String
Parameter Sets: ByOrganizationalUnitId
Aliases: OrganizationalUnitId

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name

Optional name filter parameter that can be used to only list organizational units that have
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
