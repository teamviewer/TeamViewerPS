---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/Docs/Help/Set-TeamViewerConditionalAccessRule.md
schema: 2.0.0
---

# Set-TeamViewerConditionalAccessRule

## SYNOPSIS

Updates a TeamViewer conditional access rule.

## SYNTAX

```powershell
Set-TeamViewerConditionalAccessRule -APIToken <SecureString> -Rule <Object> -Property <Hashtable> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Updates an existing conditional access rule.

## EXAMPLES

### Example 1

```powershell
Set-TeamViewerConditionalAccessRule -Rule 'r123' -Property @{ comment = 'Updated comment' }
```

Updates the rule properties.

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
