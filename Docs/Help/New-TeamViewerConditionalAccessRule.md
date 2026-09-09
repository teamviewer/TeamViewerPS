---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/Docs/Help/New-TeamViewerConditionalAccessRule.md
schema: 2.0.0
---

# New-TeamViewerConditionalAccessRule

## SYNOPSIS

Creates a TeamViewer conditional access rule.

## SYNTAX

```powershell
New-TeamViewerConditionalAccessRule -APIToken <SecureString> -SourceId <String> -SourceType <ConditionalAccessSourceTargetType> -TargetId <String> -TargetType <ConditionalAccessSourceTargetType> [-OptionSetId <Guid>] [-FeaturesOptionId <Guid>] [-TimeOptionId <Guid>] [-LocationOptionId <Guid>] [-ApprovalOptionId <Guid>] [-Expiration <Object[]>] [-Comment <String>] [-ModificationReason <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Creates a new conditional access rule for the selected source and target.

## EXAMPLES

### Example 1

```powershell
New-TeamViewerConditionalAccessRule -SourceId 'u123' -SourceType User -TargetId 'g456' -TargetType Group
```

Creates a rule between a user source and a group target.

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
