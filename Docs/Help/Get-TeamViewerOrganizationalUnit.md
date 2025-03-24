xternal help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/Docs/Help/Get-TeamViewerOrganizationalUnit.md
schema: 2.0.0
---

# Get-TeamViewerOrganizationalUnit

## SYNOPSIS

Returns a single or multiple TeamViewer organizational units of the associated TeamViewer company.

## SYNTAX

### List (Default)

```powershell
Get-TeamViewerOrganizationalUnit -ApiToken <SecureString> [-Recursive <Switch>] [-ParentId <String>] [-Filter <String>] [-SortBy <String>] [-SortOrder <String>] [-PageSize <int>] [-PageNumber <int>][<CommonParameters>]
```

### ById

```powershell
Get-TeamViewerOrganizationalUnit -ApiToken <SecureString> [-OrganizationalUnit <PSObject>] [<CommonParameters>]
```

## EXAMPLES

### Example 1

```powershell
PS /> Get-TeamViewerOrganizationalUnit
```

Lists all TeamViewer organizational units that are associated to the TV company.

### Example 2

```powershell
PS /> Get-TeamViewerOrganizationalUnit -Id '1cbae0b5-8a2f-487a-a8cf-5b884787b52c'
```

Gets one specific TeamViewer organizational unit with the given Id `1cbae0b5-8a2f-487a-a8cf-5b884787b52c`.

### Example 3

```powershell
PS /> Get-TeamViewerOrganizationalUnit -Filter 'test'
```

Lists all TeamViewer organizational units of the TV company that have the string `test` in their name or description.

## PARAMETERS

### -ApiToken

The TeamViewer API access token.

```yaml
Type: SecureString
Parameter Sets: (All)
Aliases: Token

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```
### -OrganizationalUnit
Object that can be used to identify the organizational unit.
This can either be the organizational unit Id or an organizational unit object
that has been received using other module functions.
```yaml
Type: PSObject
Parameter Sets: ById
Aliases: Id, OrganizationalUnitId

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```
### -Recursive
A breadth-first traversal through all levels of the organizational unit hierarchy.
```yaml
Type: SwitchParameter
Parameter Sets: List
Aliases: IncludeChildren

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```
### -ParentId
Define the organizational unit where processing starts. If not set, the root OU will be used as starting point.
```yaml
Type: String
Parameter Sets: List
Aliases: StartOrganizationalUnitId

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```
### -Filter
Filter organizational units by name and description.
```yaml
Type: String
Parameter Sets: List
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```
### -SortBy
Sort organizational units by Name, CreatedAt, or UpdatedAt field.
```yaml
Type: String
Parameter Sets: List
Aliases:

Required: False
Position: Named
Default value: Name
Accept pipeline input: False
Accept wildcard characters: False
```
### -SortOrder
Sort direction of organizational units.
```yaml
Type: String
Parameter Sets: List
Aliases:

Required: False
Position: Named
Default value: Asc
Accept pipeline input: False
Accept wildcard characters: False
```
### -PageSize
The number of results per page. The default is 100. The minimum is 50, the maximum is 250.
```yaml
Type: Integer
Parameter Sets: List
Aliases:

Required: False
Position: Named
Default value: 100
Accept pipeline input: False
Accept wildcard characters: False
```
### -PageNumber
The page number of results to retrieve. The first page is 1.
```yaml
Type: Integer
Parameter Sets: List
Aliases:

Required: False
Position: Named
Default value: 1
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
