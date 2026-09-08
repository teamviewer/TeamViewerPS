---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/Docs/Help/Set-TeamViewerConditionalAccessTimeOption.md
schema: 2.0.0
---

# Set-TeamViewerConditionalAccessTimeOption

## SYNOPSIS

Updates a time option for TeamViewer conditional access rules.

## SYNTAX

```powershell
Set-TeamViewerConditionalAccessTimeOption -APIToken <SecureString> -TimeOption <Object> -Property <Hashtable> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Updates an existing conditional access time option.

## EXAMPLES

### Example 1

```powershell
Set-TeamViewerConditionalAccessTimeOption -TimeOption 't123' -Property @{ name = 'Office Hours' }
```

Updates the time option name.

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
