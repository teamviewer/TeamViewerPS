---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/Docs/Help/New-TeamViewerRole.md
schema: 2.0.0
---

# New-TeamViewerRole

## SYNOPSIS

Create a new user role.

## SYNTAX

``` powershell
New-TeamViewerRole [-ApiToken] <SecureString> [-Name] <String> [-Permissions] <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Create a new role that belongs to the TeamViewer company associated with the API access token.
The name of the new role should be unique among the roles of the TeamViewer Company.

## EXAMPLES

### Example 1

```powershell
PS /> New-TeamViewerRole -Name 'New role' -Permissions 'AllowGroupharing','ManageConnections'
```

Creates a new role with name `New role` with permissions `AllowGroupSharing` and `ManageConnections` enabled.
Please see the TeamViewer API documentation for a list of valid values.

### Example 2

```powershell
PS /> New-TeamViewerRole -Name 'New role' 
```

Creates a new role with name `New role` without any permissions.
The name should be unique among the roles of the TeamViewer Company.

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

### -Name

The name of the new user role.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Permissions

The permissions for the user role.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
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

### System.Object

A `TeamViewerPS.Role` object.

## NOTES

## RELATED LINKS
