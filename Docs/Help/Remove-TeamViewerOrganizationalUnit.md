---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/Docs/Help/Remove-TeamViewerOrganizationalUnit.md
schema: 2.0.0
---

# Remove-TeamViewerOrganizationalUnit

## SYNOPSIS

Delete an organizational unit in the associated TeamViewer company.

## SYNTAX

```powershell
Remove-TeamViewerOrganizationalUnit [-ApiToken] <SecureString> [-OrganizationalUnit] <Object> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Deletes an existing organizational unit in the associated TeamViewer company.

## EXAMPLES

### Example 1

```powershell
PS /> Remove-TeamViewerOrganizationalUnit -Id '1cbae0b5-8a2f-487a-a8cf-5b884787b52c'
```

Delete an organizational unit with the given Id `1cbae0b5-8a2f-487a-a8cf-5b884787b52c` in the associated TeamViewer company.

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

### -OrganizationalUnit

Object that can be used to identify the organizational unit.
This can either be the organizational unit Id or a organizational unit object
that has been received using other module functions.

```yaml
Type: Object
Parameter Sets: (All)
Aliases: Id, OrganizationalUnitId

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
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
