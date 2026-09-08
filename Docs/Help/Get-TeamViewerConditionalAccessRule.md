---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/Docs/Help/Get-TeamViewerConditionalAccessRule.md
schema: 2.0.0
---

# Get-TeamViewerConditionalAccessRule

## SYNOPSIS

Retrieves TeamViewer conditional access rules.

## SYNTAX

```powershell
Get-TeamViewerConditionalAccessRule -APIToken <SecureString> [<CommonParameters>]
```

## DESCRIPTION

Returns the conditional access rules configured for the current TeamViewer account.

## EXAMPLES

### Example 1

```powershell
Get-TeamViewerConditionalAccessRule
```

Lists all conditional access rules.

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
