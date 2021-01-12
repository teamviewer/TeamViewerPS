---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version:
schema: 2.0.0
---

# Get-TeamViewerAccount

## SYNOPSIS

Retrieves account information of the TeamViewer account.

## SYNTAX

```powershell
Get-TeamViewerAccount [-ApiToken] <SecureString> [<CommonParameters>]
```

## DESCRIPTION

Retrieves account information of the TeamViewer account associated with the
TeamViewer API access token.

## EXAMPLES

### Example 1

```powershell
PS /> $account = Get-TeamViewerAccount
```

Retrieve the account information and store the result in a variable.

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
