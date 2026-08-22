---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/Docs/Help/Get-TeamViewerLicense.md
schema: 2.0.0
---

# Get-TeamViewerLicense

## SYNOPSIS

Retrieves company / tenant license details of the TeamViewer company associated with the API token.

## SYNTAX

```powershell
Get-TeamViewerLicense [-ApiToken] <SecureString> [<CommonParameters>]
```

## DESCRIPTION

Retrieves the company license details of the TeamViewer company associated with the
TeamViewer API access token.

## EXAMPLES

### Example 1

```powershell
PS /> $license = Get-TeamViewerLicense
```

Retrieve the company license details and store the result in a variable.

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

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningWarning. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### TeamViewerPS.License

## NOTES

## RELATED LINKS
