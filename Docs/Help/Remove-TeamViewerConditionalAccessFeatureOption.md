---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/Docs/Help/Remove-TeamViewerConditionalAccessFeatureOption.md
schema: 2.0.0
---

# Remove-TeamViewerConditionalAccessFeatureOption

## SYNOPSIS

Removes a feature option for TeamViewer conditional access rules.

## SYNTAX

```powershell
Remove-TeamViewerConditionalAccessFeatureOption -APIToken <SecureString> -FeatureOption <Object> [-ModificationReason <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Deletes a conditional access feature option.

## EXAMPLES

### Example 1

```powershell
Remove-TeamViewerConditionalAccessFeatureOption -FeatureOption 'f123'
```

Removes the feature option identified by the provided Id.

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
