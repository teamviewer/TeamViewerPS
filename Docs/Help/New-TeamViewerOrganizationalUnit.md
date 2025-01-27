---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/Docs/Help/New-TeamViewerOrganizationalUnit.md
schema: 2.0.0
---

# New-TeamViewerOrganizationalUnit

## SYNOPSIS

Create a new organizational unit in the associated TeamViewer company.

## SYNTAX

```powershell
New-TeamViewerOrganizationalUnit [-ApiToken] <SecureString> [-Name] <String> [-Description] <String> [-Parent] <String> [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION

Create a new organizational unit in the associated TV company.

## EXAMPLES

### Example 1

```powershell
PS /> New-TeamViewerOrganizationalUnit -Name 'Test'
```

Create a new organizational unit with the given name `Test` directly below root organizational unit.

### Example 2

```powershell
PS /> New-TeamViewerOrganizationalUnit -Name 'Test' -Description 'Test organizational unit' -Parent '1cbae0b5-8a2f-487a-a8cf-5b884787b52c'
```

Create a new organizational unit with the given name `Test` with description below an specific organizational unit.

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

Name of the new organizational unit.

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

### -Description

Description of the new organizational unit.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Parent

Id of the parent organizational unit.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
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
