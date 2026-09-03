---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/Docs/Help/Get-TeamViewerCompany.md
schema: 2.0.0
---

# Get-TeamViewerCompany

## SYNOPSIS

Retrieves company / tenant details of the TeamViewer company associated with the API token.

## SYNTAX

```powershell
Get-TeamViewerCompany [-ApiToken] <SecureString> [<CommonParameters>]
```

## DESCRIPTION

Retrieves the company / tenant details of the TeamViewer company associated with the TeamViewer API access token.

## EXAMPLES

### Example 1

```powershell
$company = Get-TeamViewerCompany
```

Retrieve the company details and store the result in a variable.

### Example 2

```powershell
Get-TeamViewerCompany | Select-Object -Property Name, CreatedAt
```

Retrieves the company details and shows only the `Name` and `CreatedAt` properties.

### Example 3

```powershell
(Get-TeamViewerCompany).Id
```

Retrieves the company details and returns only the numeric company Id.

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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### TeamViewerPS.Company

## NOTES

## RELATED LINKS
