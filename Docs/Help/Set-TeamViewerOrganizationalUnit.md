---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/Docs/Help/Set-TeamViewerOrganizationalUnit.md
schema: 2.0.0
---

# Set-TeamViewerOrganizationalUnit

## SYNOPSIS

Change an existing organizational unit in the associated TeamViewer company.

## SYNTAX

### ByParameters (Default)

```powershell
Set-TeamViewerOrganizationalUnit -ApiToken <SecureString> -OrganizationalUnit <Object> [-Name <String>] [-Description <String>] [-Parent <String>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

### ByProperties

```powershell
Set-TeamViewerOrganizationalUnit -ApiToken <SecureString> -OrganizationalUnit <Object> -Property <Hashtable> [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION

Changes an existing organizational unit in the associated TeamViewer company.

## EXAMPLES

### Example 1

```powershell
PS /> Set-TeamViewerOrganizationalUnit -OrganizationalUnit '1cbae0b5-8a2f-487a-a8cf-5b884787b52c' -Name 'New organizational unit name'
```

Change the name of the organizational unit with the given Id `1cbae0b5-8a2f-487a-a8cf-5b884787b52c` to `New organizational unit name`.

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

### -OrganizationalUnit

Object that can be used to identify the organizational unit.
This can either be the organizational unit Id or a organizational unit object that has been received using other module functions.

```yaml
Type: Object
Parameter Sets: (All)
Aliases: Id, OrganizationalUnitId

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Name

The new name of the organizational unit.

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

### -Description

The new description of the organizational unit.

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

### -Parent

The new parent of the organizational unit.

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

### -Property

Change organizational unit information using a hashtable object.
Valid hashtable keys are: `name`, `description`, `parent`

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

## OUTPUTS

## NOTES

## RELATED LINKS
