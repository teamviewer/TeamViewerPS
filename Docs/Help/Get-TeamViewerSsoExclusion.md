---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/Docs/Help/Get-TeamViewerSsoExclusion.md
schema: 2.0.0
---

# Get-TeamViewerSsoExclusion

## SYNOPSIS

Get the list of excluded email addresses for a given TeamViewer SSO domain.

## SYNTAX

```powershell
Get-TeamViewerSsoExclusion [-ApiToken] <SecureString> [-DomainId] <Object> [<CommonParameters>]
```

## DESCRIPTION

Get the list of excluded email addresses for a given TeamViewer SSO domain.
These email addresses are excluded from logging in via Single Sign-On and
instead must login using their TeamViewer account password.

## EXAMPLES

### Example 1

```powershell
PS /> Get-TeamViewerSsoExclusion -DomainId '45e0d050-15e6-4fcb-91b2-ea4f20fe2085'
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

### -DomainId

Object that can be used to identify the SSO domain to get exclusion entries for.
This can either be the SSO domain ID (as string or GUID) or a SsoDomain
object that has been received using the `Get-TeamViewerSsoDomain` function.

```yaml
Type: Object
Parameter Sets: (All)
Aliases: Domain

Required: True
Position: 1
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

[Get-TeamViewerSsoDomain](Get-TeamViewerSsoDomain.md)

[Add-TeamViewerSsoExclusion](Add-TeamViewerSsoExclusion.md)

[Remove-TeamViewerSsoExclusion](Remove-TeamViewerSsoExclusion.md)
