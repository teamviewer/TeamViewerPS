---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/Docs/Help/Get-TeamViewerSsoDomain.md
schema: 2.0.0
---

# Get-TeamViewerSsoDomain

## SYNOPSIS

Get a list of TeamViewer Single Sign-On (SSO) domains that are owned by the current account.

## SYNTAX

```powershell
Get-TeamViewerSsoDomain [-ApiToken] <SecureString> [-Id <Guid>] [<CommonParameters>]
```

## DESCRIPTION

Get a list of TeamViewer Single Sign-On (SSO) domain configurations that are owned by the account that is associated with the API access token.

## EXAMPLES

### Example 1

```powershell
Get-TeamViewerSsoDomain
```

### Example 2

```powershell
Get-TeamViewerSsoDomain -Domain 'c0cb303a-8a85-4e54-b657-a4757c791aef'
```

Retrieves the SSO domain configuration with the specified domain id.

### Example 3

```powershell
Get-TeamViewerSsoDomain | Where-Object { $_.Name -eq 'example.com' }
```

Lists only the SSO domain whose name is 'example.com'.

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

### -Id

The TeamViewer SSO domain id.

```yaml
Type: Guid
Parameter Sets: ByDomainId
Aliases: DomainId

Required: False
Position: Named
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
