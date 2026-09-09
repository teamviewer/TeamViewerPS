---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/Docs/Help/Set-TeamViewerConditionalAccessApprovalOption.md
schema: 2.0.0
---

# Set-TeamViewerConditionalAccessApprovalOption

## SYNOPSIS

Updates an approval option for TeamViewer conditional access rules.

## SYNTAX

```powershell
Set-TeamViewerConditionalAccessApprovalOption -APIToken <SecureString> -ApprovalOption <Object> -Property <Hashtable> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Updates an existing conditional access approval option.

## EXAMPLES

### Example 1

```powershell
Set-TeamViewerConditionalAccessApprovalOption -ApprovalOption 'a123' -Property @{ name = 'Manual approval' }
```

Updates the approval option name.

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
