---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/Docs/Help/New-TeamViewerOrganizationalUnit.md
schema: 2.0.0
---

# New-TeamViewerOrganizationalUnit

## SYNOPSIS

Creates a TeamViewer organizational unit in the associated TeamViewer company.

## SYNTAX

```powershell
New-TeamViewerOrganizationalUnit [-ApiToken] <SecureString> [-Name] <String> [-Description] <String> [-ParentId] <String> [-Confirm] [-WhatIf] [<CommonParameters>]
```

## EXAMPLES

### Example 1

```powershell
PS /> New-TeamViewerOrganizationalUnit -Name 'Test'
```

Creates a new organizational unit with the given name `Test` directly below the root organizational unit.

### Example 2

```powershell
PS /> New-TeamViewerOrganizationalUnit -Name 'Test' -Description 'Test organizational unit' -Parent '1cbae0b5-8a2f-487a-a8cf-5b884787b52c'
```

Creates a new organizational unit with the given name `Test` with description below a specific organizational unit.

## PARAMETERS

### -ApiToken

The TeamViewer API access token.

```yaml
Type: SecureString
Parameter Sets: (All)
Aliases: Token

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name

The name of the new organizational unit.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description

The description of the new organizational unit.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ParentId

Id of the parent organizational unit.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf

Shows what would happen if the cmdlet runs.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

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
