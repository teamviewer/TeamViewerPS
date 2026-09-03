---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/Docs/Help/New-TeamViewerUserGroup.md
schema: 2.0.0
---

# New-TeamViewerUserGroup

## SYNOPSIS

Create a new user group.

## SYNTAX

``` powershell
New-TeamViewerUserGroup [-ApiToken] <SecureString> [-Name] <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Create a new user group that belongs to the TeamViewer company associated with the API access token.
The name of the new user group should be unique among the groups of the TeamViewer Company.

## EXAMPLES

### Example 1

```powershell
New-TeamViewerUserGroup -Name 'New user group'
```

Creates a new user groups with name `New user group`.
The name should be unique among the groups of the TeamViewer Company.

### Example 2

```powershell
$userGroup = New-TeamViewerUserGroup -Name 'Support Team'
```

Creates a new user group and stores the returned user group object in a variable.

### Example 3

```powershell
'Support Team', 'Sales Team' | ForEach-Object { New-TeamViewerUserGroup -Name $_ }
```

Creates multiple user groups in a single pipeline.

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

The name of the new user group.

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

A `TeamViewerPS.UserGroup` object.

## NOTES

## RELATED LINKS
