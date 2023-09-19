---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: 
schema: 2.0.0
---

# Add-TeamViewerRoleToAccount

## SYNOPSIS

Assign user role to a list of accountIds.

## SYNTAX

```powershell
Add-TeamViewerRoleToAccount [-ApiToken] <SecureString> [-UserRoleId] <Object> [-Account] <string[]> [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Assigns user role to one or many users. User role should belong to the TeamViewer company associated with the API access token.

## EXAMPLES

### Example 1

```powershell
PS /> Add-TeamViewerRoleToAccount -UserRoleId  '9b465ea2-2f75-4101-a057-58a81ed0e57b' -Account @('123', '456', '789')
```

Assigns role with id `9b465ea2-2f75-4101-a057-58a81ed0e57b` to users with id `123`, `456`, `789`.

### Example 2

```powershell
PS /> @('123', '456', '789') | Add-TeamViewerRoleToAccount -UserRole '9b465ea2-2f75-4101-a057-58a81ed0e57b'
```

Assigns role with id `9b465ea2-2f75-4101-a057-58a81ed0e57b` to users with id `123`, `456`, `789`.
Ids are passed as pipeline input.

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

The role to which users will be assigned to.

```yaml
Type: Object
Parameter Sets: (All)
Aliases: UserRole

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Account

Users to be assigned to a user role.

```yaml
Type: string[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
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

### System.string[]

An array of account Ids.

## OUTPUTS

## NOTES

## RELATED LINKS
