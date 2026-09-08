---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/Docs/Help/Get-TeamViewerConditionalAccessTimeOption.md
schema: 2.0.0
---

# Get-TeamViewerConditionalAccessTimeOption

## SYNOPSIS

Retrieves the time options for TeamViewer conditional access rules.

## SYNTAX

```powershell
Get-TeamViewerConditionalAccessTimeOption -APIToken <SecureString> [<CommonParameters>]
```

## DESCRIPTION

Returns the available time options configured for conditional access.

## EXAMPLES

### Example 1

```powershell
Get-TeamViewerConditionalAccessTimeOption
```

Lists the time options available for conditional access.

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

This cmdlet supports the common parameters.

## INPUTS

### None

## OUTPUTS

## NOTES

## RELATED LINKS
