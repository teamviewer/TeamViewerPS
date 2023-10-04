---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/Docs/Help/Connect-TeamViewerApi.md
schema: 2.0.0
---

# Connect-TeamViewerApi

## SYNOPSIS

Store the TeamViewer API access token in the current environment.

## SYNTAX

```powershell
Connect-TeamViewerApi [-ApiToken] <SecureString> [<CommonParameters>]
```

## DESCRIPTION

Stores the TeamViewer API access token in the current environment such that
API related function don't need to specify the `ApiToken` parameter anymore.

## EXAMPLES

### Example 1

```powershell
PS /> Connect-TeamViewerApi
*********************
PS /> Get-TeamViewerUser
```

Use `Connect-TeamViewerApi` to store the TeamViewer API access token as secure
string in the current Powershell global scope.

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

### None

## OUTPUTS

## NOTES

## RELATED LINKS

[Disconnect-TeamViewerApi](Disconnect-TeamViewerApi.md)
