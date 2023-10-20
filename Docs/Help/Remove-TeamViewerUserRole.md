---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/Docs/Help/Remove-TeamViewerRole.md
schema: 2.0.0
---

# Remove-TeamViewerRole

## SYNOPSIS

Deletes one specific role from the TeamViewer company.

## SYNTAX

```powershell
Remove-TeamViewerRole [-ApiToken] <SecureString> [-UserRoleId] <Object> [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION

Deletes one specific role from the TeamViewer company.
All permissions and user assignments of the role will be deleted too.

## EXAMPLES

### Example 1

```powershell
PS /> Remove-TeamViewerRole -UserRoleId '9b465ea2-2f75-4101-a057-58a81ed0e57b'
```

Deletes the role with Id `9b465ea2-2f75-4101-a057-58a81ed0e57b`.

### Example 2

```powershell
PS />  Remove-TeamViewerRole -UserRoleId (Get-TeamViewerRole | Where-Object { ($_.RoleName -eq 'Test Role') } ).RoleID
```

Deletes a role with the role Id retrieved from `Get-TeamViewerRole` as input.
In this example, the role with the name `Test Role`.

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

### -UserRoleId

The role to be deleted.

```yaml
Type: Object
Parameter Sets: (All)
Aliases: Id, UserRole

Required: True
Position: 1
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

### None

## OUTPUTS

## NOTES

## RELATED LINKS
