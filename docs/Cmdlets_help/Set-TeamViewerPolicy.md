---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/Docs/Cmdlets_help/Set-TeamViewerPolicy.md
schema: 2.0.0
---

# Set-TeamViewerPolicy

## SYNOPSIS

Change a TeamViewer policy.

## SYNTAX

### ByParameters (Default)

```powershell
Set-TeamViewerPolicy -ApiToken <SecureString> -Policy <Object> [-Name <String>] [-Settings <Object[]>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

### ByProperties

```powershell
Set-TeamViewerPolicy -ApiToken <SecureString> -Policy <Object> -Property <Hashtable> [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION

Modifies settings of a TeamViewer policy.

## EXAMPLES

### Example 1

```powershell
PS /> Set-TeamViewerPolicy -Policy '730ee15a-1ea4-4d80-9cfe-5a01709d0a2f' -Name 'New Policy Name'
```

Change the name of the given TeamViewer policy.

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

### -Name

New name of the policy.

```yaml
Type: String
Parameter Sets: ByParameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Policy

Object that can be used to identify the policy.
This can either be the policy ID (as string or GUID) or a policy object that has
been received using other module functions.

```yaml
Type: Object
Parameter Sets: (All)
Aliases: PolicyId

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Property

Change policy information using a hashtable object.
Valid hashtable keys are: `name`, `settings`

```yaml
Type: Hashtable
Parameter Sets: ByProperties
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Settings

Change settings of the TeamViewer policy.
Must be objects with the following properties:

`key`: The label of a setting

`value`: The value of a setting

`enforce`: `true` or `false`. Enforced settings cannot be changed on the device
itself.

```yaml
Type: Object[]
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
