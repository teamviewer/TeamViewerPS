---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/Docs/Help/Remove-TeamViewerDefaultRole.md
schema: 2.0.0
---

# Remove-TeamViewerDefaultRole

## SYNOPSIS

Sets the existing default role to a not default one.

## SYNTAX

```powershell
Remove-TeamViewerDefaultRole [-APIToken] <SecureString> [-RoleId] <Object> [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION

Sets the existing default role to a not default one. The role is still available.
The user assignments of this role are unaffected.

## EXAMPLES

### Example 1

```powershell
Remove-TeamViewerDefaultRole 
```

Removes the default role flag from the role.

### Example 2

```powershell
Remove-TeamViewerDefaultRole -WhatIf
```

Shows what would happen without actually removing the default role flag.

### Example 3

```powershell
Remove-TeamViewerDefaultRole -Confirm:$false
```

Removes the default role flag without prompting for confirmation.

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
