---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/Docs/Help/New-TeamViewerConditionalAccessFeatureOption.md
schema: 2.0.0
---

# New-TeamViewerConditionalAccessFeatureOption

## SYNOPSIS

Creates a feature option for TeamViewer conditional access rules.

## SYNTAX

```powershell
New-TeamViewerConditionalAccessFeatureOption -APIToken <SecureString> [-Name <String>] [-Description <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Creates a new feature option entry used by conditional access policies.

## EXAMPLES

### Example 1

```powershell
New-TeamViewerConditionalAccessFeatureOption -Name 'LocalInput'
```

Creates a new feature option with a friendly name.

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
