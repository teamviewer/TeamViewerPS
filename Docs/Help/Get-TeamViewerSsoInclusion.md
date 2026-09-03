---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/Docs/Help/Get-TeamViewerSsoInclusion.md
schema: 2.0.0
---

# Get-TeamViewerSsoInclusion

## SYNOPSIS

Get the list of included email addresses for a given TeamViewer Single Sign-On (SSO) domain.

## SYNTAX

```powershell
Get-TeamViewerSsoInclusion [-ApiToken] <SecureString> [-DomainId] <Object> [<CommonParameters>]
```

## DESCRIPTION

Get the list of included email addresses for a given TeamViewer Single Sign-On (SSO) domain.
These email addresses are included from logging in via Single Sign-On and do not have to login using their TeamViewer account password.

## EXAMPLES

### Example 1

```powershell
Get-TeamViewerSsoInclusion -DomainId '45e0d050-15e6-4fcb-91b2-ea4f20fe2085'
```

### Example 2

```powershell
$domain = Get-TeamViewerSsoDomain -DomainId '45e0d050-15e6-4fcb-91b2-ea4f20fe2085'
Get-TeamViewerSsoInclusion -Domain $domain
```

Gets the included email addresses by passing a SsoDomain object retrieved with `Get-TeamViewerSsoDomain`.

### Example 3

```powershell
Get-TeamViewerSsoInclusion -SsoDomainId 'c0cb303a-8a85-4e54-b657-a4757c791aef'
```

Gets the included email addresses for the SSO domain using the `SsoDomainId` alias.

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

Object that can be used to identify the SSO domain to get inclusion entries for.
This can either be the SSO domain Id (as string or GUID) or a SsoDomain object that has been received using the `Get-TeamViewerSsoDomain` function.

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

[Add-TeamViewerSsoInclusion](Add-TeamViewerSsoInclusion.md)

[Remove-TeamViewerSsoInclusion](Remove-TeamViewerSsoInclusion.md)
