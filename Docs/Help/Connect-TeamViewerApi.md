---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/Docs/Help/Connect-TeamViewerAPI.md
schema: 2.0.0
---

# Connect-TeamViewerAPI

## SYNOPSIS

Store the TeamViewer API access token in the current environment.

## SYNTAX

```powershell
Connect-TeamViewerAPI [-APIToken] <SecureString> [<CommonParameters>]
```

## DESCRIPTION

Stores the TeamViewer API access token in the current environment such that API related function don't need to specify the `APIToken` parameter anymore.

## EXAMPLES

### Example 1

```powershell
Connect-TeamViewerAPI
Get-TeamViewerUser
```

Use `Connect-TeamViewerAPI` to store the TeamViewer API access token as secure string in the current Powershell global scope.

### Example 2

```powershell
$APIToken = 'MyAPIToken' | ConvertTo-SecureString -AsPlainText -Force

Connect-TeamViewerAPI -APIToken $APIToken
```

Stores an API access token that has already been converted to a secure string in the current environment.

### Example 3

```powershell
Connect-TeamViewerAPI -APIToken (Get-Secret -Name 'TeamViewerAPIToken')
```

Retrieves the API access token from a secret store and stores it in the current environment.

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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

## NOTES

## RELATED LINKS

[Disconnect-TeamViewerAPI](Disconnect-TeamViewerAPI.md)
