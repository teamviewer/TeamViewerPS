---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/Docs/Help/Get-TeamViewerSSOInclusion.md
schema: 2.0.0
---

# Get-TeamViewerSSOInclusion

## SYNOPSIS

Get the list of included email addresses for a given TeamViewer Single Sign-On (SSO) domain.

## SYNTAX

```powershell
Get-TeamViewerSSOInclusion [-APIToken] <SecureString> [-DomainId] <Object> [<CommonParameters>]
```

## DESCRIPTION

Get the list of included email addresses for a given TeamViewer Single Sign-On (SSO) domain.
These email addresses are included from logging in via Single Sign-On and do not have to login using their TeamViewer account password.

## EXAMPLES

### Example 1

```powershell
Get-TeamViewerSSOInclusion -DomainId '45e0d050-15e6-4fcb-91b2-ea4f20fe2085'
```

### Example 2

```powershell
$domain = Get-TeamViewerSSODomain -DomainId '45e0d050-15e6-4fcb-91b2-ea4f20fe2085'
Get-TeamViewerSSOInclusion -Domain $domain
```

Gets the included email addresses by passing a SSODomain object retrieved with `Get-TeamViewerSSODomain`.

### Example 3

```powershell
Get-TeamViewerSSOInclusion -SSODomainId 'c0cb303a-8a85-4e54-b657-a4757c791aef'
```

Gets the included email addresses for the SSO domain using the `SSODomainId` alias.

## PARAMETERS

### -APIToken

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
This can either be the SSO domain Id (as string or GUID) or a SSODomain object that has been received using the `Get-TeamViewerSSODomain` function.

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

[Get-TeamViewerSSODomain](Get-TeamViewerSSODomain.md)

[Add-TeamViewerSSOInclusion](Add-TeamViewerSSOInclusion.md)

[Remove-TeamViewerSSOInclusion](Remove-TeamViewerSSOInclusion.md)
