---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/Docs/Help/Remove-TeamViewerPredefinedRole.md
schema: 2.0.0
---

# Remove-TeamViewerPredefinedRole

## SYNOPSIS

Sets the existing predefined role to a not predefined one.

## SYNTAX

```powershell
Remove-TeamViewerPredefinedRole [-ApiToken] <SecureString> [-RoleId] <Object> [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION

Sets the existing predefined role to a not predefined one. The role is still available.
The user assignments of this role are unaffected.

## EXAMPLES

### Example 1

```powershell
Remove-TeamViewerPredefinedRole 
```

Removes the predefined role flag from the role.

### Example 2

```powershell
Remove-TeamViewerPredefinedRole -WhatIf
```

Shows what would happen without actually removing the predefined role flag.

### Example 3

```powershell
Remove-TeamViewerPredefinedRole -Confirm:$false
```

Removes the predefined role flag without prompting for confirmation.

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
