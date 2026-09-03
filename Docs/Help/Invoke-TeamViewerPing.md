---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/Docs/Help/Invoke-TeamViewerPing.md
schema: 2.0.0
---

# Invoke-TeamViewerPing

## SYNOPSIS

Test the given TeamViewer API access token to be valid.

## SYNTAX

```powershell
Invoke-TeamViewerPing [-ApiToken] <SecureString> [<CommonParameters>]
```

## DESCRIPTION

This command tests the availability of the TeamViewer Web API and the validity of the given API access token.

## EXAMPLES

### Example 1

```powershell
Invoke-TeamViewerPing
```

### Example 2

```powershell
$isValid = Invoke-TeamViewerPing
```

Stores whether the API access token is valid in a variable.

### Example 3

```powershell
if (Invoke-TeamViewerPing) { 'Token is valid' }
```

Runs a follow-up action only when the API access token is valid.

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

## NOTES

## RELATED LINKS
