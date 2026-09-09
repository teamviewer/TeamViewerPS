---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/Docs/Help/Remove-TeamViewerConditionalAccessRule.md
schema: 2.0.0
---

# Remove-TeamViewerConditionalAccessRule

## SYNOPSIS

Removes a TeamViewer conditional access rule.

## SYNTAX

```powershell
Remove-TeamViewerConditionalAccessRule -APIToken <SecureString> -Rule <Object> [-ModificationReason <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Deletes an existing conditional access rule.

## EXAMPLES

### Example 1

```powershell
Remove-TeamViewerConditionalAccessRule -Rule 'r123'
```

Removes the conditional access rule identified by the provided Id.

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
