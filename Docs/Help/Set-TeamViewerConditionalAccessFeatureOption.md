---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/Docs/Help/Set-TeamViewerConditionalAccessFeatureOption.md
schema: 2.0.0
---

# Set-TeamViewerConditionalAccessFeatureOption

## SYNOPSIS

Updates a feature option for TeamViewer conditional access rules.

## SYNTAX

```powershell
Set-TeamViewerConditionalAccessFeatureOption -APIToken <SecureString> -FeatureOption <Object> -Property <Hashtable> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Updates an existing conditional access feature option.

## EXAMPLES

### Example 1

```powershell
Set-TeamViewerConditionalAccessFeatureOption -FeatureOption 'f123' -Property @{ name = 'Screen Sharing' }
```

Updates the feature option name.

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
