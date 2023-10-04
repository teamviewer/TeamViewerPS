---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/Docs/Help/Set-TeamViewerUserRole.md
schema: 2.0.0
---

# Set-TeamViewerUserRole

## SYNOPSIS

Update properties of a user role.

## SYNTAX

```powershell
Set-TeamViewerUserRole [-ApiToken] <SecureString> [-Name] <String> [-UserRoleId] <Object> [-Permissions] <Array> [-WhatIf] [-Confirm]  [<CommonParameters>]
```

## DESCRIPTION

Update properties of a user role. It allows to rename and alter permissions.

## EXAMPLES

### Example 1

```powershell
PS /> Set-TeamViewerUserRole -Name 'New name of user role' -Permissions 'AllowGroupSharing','ModifyConnections' -UserRoleId '9b465ea2-2f75-4101-a057-58a81ed0e57b'
```

Renames a user role with id `9b465ea2-2f75-4101-a057-58a81ed0e57b` to `New name of user role` and enables the permissions `AllowGroupSharing` and `ModifyConnections`.

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

### -Name

The new name of the User role.

```yaml
Type: String
Parameter Sets: (All)
Aliases: UserRoleName

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -UserRoleId

The user role to be updated.

```yaml
Type: Object
Parameter Sets: (All)
Aliases: UserRole

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Permissions

Updated set of permissions of the user role.
Please see the TeamViewer API documentation for a list of valid values.

```yaml
Type: Array
Parameter Sets: ByParameters
Aliases:

Required: False
Position: Named
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
