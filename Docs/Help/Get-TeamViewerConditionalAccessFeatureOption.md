---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/Docs/Help/Get-TeamViewerConditionalAccessFeatureOption.md
schema: 2.0.0
---

# Get-TeamViewerConditionalAccessFeatureOption

## SYNOPSIS

Retrieves the feature options for TeamViewer conditional access rules.

## SYNTAX

```powershell
Get-TeamViewerConditionalAccessFeatureOption -APIToken <SecureString> [<CommonParameters>]
```

## DESCRIPTION

Returns the available feature options configured for conditional access.

## EXAMPLES

### Example 1

```powershell
Get-TeamViewerConditionalAccessFeatureOption
```

Lists the feature options available for conditional access.

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
