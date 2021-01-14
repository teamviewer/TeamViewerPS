---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version:
schema: 2.0.0
---

# Get-TeamViewerSsoDomain

## SYNOPSIS

Get a list of TeamViewer SSO domains that are owned by the current account.

## SYNTAX

```powershell
Get-TeamViewerSsoDomain [-ApiToken] <SecureString> [<CommonParameters>]
```

## DESCRIPTION

Get a list of TeamViewer SSO domain configurations that are owned by the
account that is associated with the API access token.

## EXAMPLES

### Example 1

```powershell
PS /> Get-TeamViewerSsoDomain
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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[Get-TeamViewerSsoExclusion](Get-TeamViewerSsoExclusion.md)

[Add-TeamViewerSsoExclusion](Add-TeamViewerSsoExclusion.md)

[Remove-TeamViewerSsoExclusion](Remove-TeamViewerSsoExclusion.md)
