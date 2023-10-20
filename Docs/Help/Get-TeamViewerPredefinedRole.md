---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/Docs/Help/Get-TeamViewerPredefinedRole.md
schema: 2.0.0
---

# Get-TeamViewerPredefinedRole

## SYNOPSIS

Retrieve the Predefine Role in a TeamViewer company.

## SYNTAX

```powershell
Get-TeamViewerPredefinedRole [-ApiToken] <SecureString> [<CommonParameters>]
```

## DESCRIPTION

Retrieves the Predefined role among the existing roles in the TeamViewer company associated with the API access token.

## EXAMPLES

### Example 1

```powershell
PS /> Get-TeamViewerPredefinedRole
```

Retrieves the Predefined Role ID.

### Example 2

```powershell
PS /> forEach-Object { Get-TeamViewerRole | Where-Object { $_.RoleID -eq (Get-TeamViewerPredefinedRole).PredefinedRoleID } }
```

Retrieves the complete information about the predefined role.

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

An array of `TeamViewerPS.PredefinedRole` objects.

## NOTES

## RELATED LINKS
