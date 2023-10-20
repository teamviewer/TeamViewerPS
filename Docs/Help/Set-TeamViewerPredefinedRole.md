---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/Docs/Help/Set-TeamViewerPredefinedRole.md
schema: 2.0.0
---

# Set-TeamViewerPredefinedRole

## SYNOPSIS

Sets an existing role as predefined role.

## SYNTAX

```powershell
Set-TeamViewerPredefinedRole [-ApiToken] <SecureString> [-RoleId] <Object> [<CommonParameters>]
```

## DESCRIPTION

Sets an existing role as predefined role.
Every new user will get the predefined role assigned automatically during creation.

## EXAMPLES

### Example 1

```powershell
PS /> Set-TeamViewerPredefinedRole -RoleId '9b465ea2-2f75-4101-a057-58a81ed0e57b'
```

Sets the role with the id `9b465ea2-2f75-4101-a057-58a81ed0e57b` as predefined role.

### Example 1

```powershell
PS /> Get-TeamViewerRole | where-Object { ($_.RoleName -eq 'Test Role') } | Set-TeamViewerPredefinedRole
```

Sets the role with name `Test Role` as predefined role.

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

### -RoleId

The role to be set as Predefined Role.

```yaml
Type: Object
Parameter Sets: (All)
Aliases: UserRole

Required: True
Position: 1
Default value: None
Accept pipeline input: True
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

## NOTES

## RELATED LINKS
