---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/Docs/Help/New-TeamViewerConditionalAccessApprovalOption.md
schema: 2.0.0
---

# New-TeamViewerConditionalAccessApprovalOption

## SYNOPSIS

Creates an approval option for TeamViewer conditional access rules.

## SYNTAX

```powershell
New-TeamViewerConditionalAccessApprovalOption -APIToken <SecureString> [-Name <String>] [-Description <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Creates a new approval option entry used by conditional access policies.

## EXAMPLES

### Example 1

```powershell
New-TeamViewerConditionalAccessApprovalOption -Name 'Manual Approval'
```

Creates a new approval option with a friendly name.

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
