---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/docs/Cmdlets_help/Remove-TeamViewerRoleFromAccount.md
schema: 2.0.0
---

# Remove-TeamViewerRoleFromAccount

## SYNOPSIS

Unassign role from a given list of accounts.

## SYNTAX

### ByUserRoleIdMemberId (All)

```powershell
Remove-TeamViewerRoleFromAccount [-ApiToken] <SecureString>  [-UserRoleId] <Object[]> [-Account] <Object>
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

### ByUserId

```powershell
Remove-TeamViewerRoleFromAccount [-ApiToken] <SecureString> [-UserRoleId] <Object> [-Account] <Object[]>
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Unassigns user role from one or many users. User role should belong to the TeamViewer company associated with the API access token.

## EXAMPLES

### Example 1

```powershell
PS /> Remove-TeamViewerRoleFromAccount -UserRoleId '9b465ea2-2f75-4101-a057-58a81ed0e57b' -Account @('123', '456', '789')
```

Unassigns role with id `9b465ea2-2f75-4101-a057-58a81ed0e57b` from users with id `123`, `456`, `789`.

### Example 2

```powershell
PS /> @('123', '456', '789') | Remove-TeamViewerRoleFromAccount -UserRoleId '9b465ea2-2f75-4101-a057-58a81ed0e57b'
```

Unassigns role with id `9b465ea2-2f75-4101-a057-58a81ed0e57b` from users with id `123`, `456`, `789`.
Ids are passed as pipeline input.

## PARAMETERS

### -ApiToken

The TeamViewer API access token.

```yaml
Type: SecureString
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
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

The role from where users will be unassigned from.

```yaml
Type: Object
Parameter Sets: (All)
Aliases: UserRole

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Account

Users to be unassigned from a user role.

```yaml
Type: Object[]
Parameter Sets: (All)
Aliases: Id, UserId

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
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

### System.Object

### System.string[]

An array of account Ids.

## OUTPUTS

## NOTES

## RELATED LINKS
