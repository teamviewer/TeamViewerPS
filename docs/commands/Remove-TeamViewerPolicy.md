---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version:
schema: 2.0.0
---

# Remove-TeamViewerPolicy

## SYNOPSIS

Delete a TeamViewer policy.

## SYNTAX

```powershell
Remove-TeamViewerPolicy [-ApiToken] <SecureString> [-Policy] <Object> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Delete the specified TeamViewer policy.

## EXAMPLES

### Example 1

```powershell
PS /> Remove-TeamViewerPolicy -Policy '730ee15a-1ea4-4d80-9cfe-5a01709d0a2f'
```

## PARAMETERS

### -ApiToken

The TeamViewer API access token.

```yaml
Type: SecureString
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm

Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Policy

Object that can be used to identify the policy.
This can either be the policy ID (as string or GUID) or a policy object that has
been received using other module functions.

```yaml
Type: Object
Parameter Sets: (All)
Aliases: PolicyId

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -WhatIf

Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Object

## OUTPUTS

## NOTES

## RELATED LINKS
