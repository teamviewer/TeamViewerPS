---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/Docs/Help/Remove-TeamViewerSsoInclusion.md
schema: 2.0.0
---

# Remove-TeamViewerSsoInclusion

## SYNOPSIS

Remove emails from the inclusion list of a TeamViewer Single Sign-On domain.

## SYNTAX

```powershell
Remove-TeamViewerSsoInclusion [-ApiToken] <SecureString> [-DomainId] <Object> [-Email] <String[]> [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Remove emails from the inclusion list of a TeamViewer Single Sign-On domain.
Accounts with these email addresses do need to login via Single
Sign-On and do not have to use their TeamViewer account password.

## EXAMPLES

### Example 1

```powershell
PS /> Remove-TeamViewerSsoInclusion -DomainId '45e0d050-15e6-4fcb-91b2-ea4f20fe2085' -Email 'user@example.test'
```

Removes the email address '<user@example.test>' from the Inclusion list of the
given domain.

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

Object that can be used to identify the SSO domain to remove inclusion entries
from.
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

### -Email

List of emails addresses to remove from the inclusion list.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByValue)
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

## OUTPUTS

## NOTES

## RELATED LINKS

[Get-TeamViewerSsoDomain](Get-TeamViewerSsoDomain.md)

[Get-TeamViewerSsoInclusion](Get-TeamViewerSsoInclusion.md)

[Add-TeamViewerSsoInclusion](Add-TeamViewerSsoInclusion.md)
