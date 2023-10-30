---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/Docs/Help/Get-TeamViewerRole.md
schema: 2.0.0
---

# Get-TeamViewerRole

## SYNOPSIS

Lists all roles and their permissions in a TeamViewer company.

## SYNTAX

```powershell
Get-TeamViewerRole [-ApiToken] <SecureString> [<CommonParameters>]
```

## DESCRIPTION

Lists all roles in the TeamViewer company associated with the API access token.

## EXAMPLES

### Example 1

```powershell
PS /> Get-TeamViewerRole
```

Lists all roles and their permissions.

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

### System.Object

An array of `TeamViewerPS.Role` objects.

## NOTES

## RELATED LINKS
