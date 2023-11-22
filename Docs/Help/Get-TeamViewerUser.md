---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/Docs/Help/Get-TeamViewerUser.md
schema: 2.0.0
---

# Get-TeamViewerUser

## SYNOPSIS

Retrieve users of a TeamViewer company.

## SYNTAX

### FilteredList (Default)

```powershell
Get-TeamViewerUser -ApiToken <SecureString> [-Name <String>] [-Email <String[]>] [-Permissions <String[]>]
 [-PropertiesToLoad <Object>] [<CommonParameters>]
```

### ByUserId

```powershell
Get-TeamViewerUser -ApiToken <SecureString> [-Id <String>] [-PropertiesToLoad <Object>] [<CommonParameters>]
```

## DESCRIPTION

Lists all users of the TeamViewer company associated with the API access token.
The list can optionally be filtered using additional parameters.

## EXAMPLES

### Example 1

```powershell
PS /> Get-TeamViewerUser
```

List all users.

### Example 2

```powershell
PS /> Get-TeamViewerUser -Id 'u1234'
```

Retrieve a single user entry with the given ID.

### Example 3

```powershell
PS /> Get-TeamViewerUser -Name 'Test' -PropertiesToLoad 'All'
```

List all users of the company that have the string `Test` in their name.
The resulting list entries should contain all available user properties.

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

### -Email

Optional list of email addresses. Can be used to only return users that exactly match one of the given email addresses.

```yaml
Type: String[]
Parameter Sets: FilteredList
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Id

User ID to return only a single user entry with that ID.

```yaml
Type: String
Parameter Sets: ByUserId
Aliases: UserId

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name

Optional name filter parameter that can be used to only list users that have the given string in their name.

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

### -Permissions

Optional permissions filter that can be used to only list users that have
certain permissions. Multiple values can be given.

```yaml
Type: String[]
Parameter Sets: FilteredList
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PropertiesToLoad

Can be used to retrieve all available properties of a user or just a stripped-down minimal set of user properties.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:
Accepted values: All, Minimal

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
