---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/Docs/Help/Set-TeamViewerAddressBook.md
schema: 2.0.0
---

# Set-TeamViewerAddressBook

## SYNOPSIS

Change company address book settings.

## SYNTAX

### ByParameters (Default)

```powershell
Set-TeamViewerAddressBook -APIToken <SecureString> [-Enabled <Boolean>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### ByProperties

```powershell
Set-TeamViewerAddressBook -APIToken <SecureString> -Property <Hashtable> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Changes address book settings of the TeamViewer company associated with the API access token.

## EXAMPLES

### Example 1

```powershell
Set-TeamViewerAddressBook -APIToken $token -Enabled $false
```

Disable the address book for the company.

### Example 2

```powershell
Set-TeamViewerAddressBook -APIToken $token -Property @{ addressBookAvailable = $true }
```

Change multiple address book settings using a hashtable.

## PARAMETERS

### -APIToken

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

### -Enabled

Enable or disable the address book for the company.

```yaml
Type: Boolean
Parameter Sets: ByParameters
Aliases:

Required: False
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

### -Property

Change address book settings using a hashtable object.
Valid hashtable keys are:
`addressBookAvailable`

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

### System.Void

## NOTES

Requires at least one parameter change. An error is thrown if no changes are specified.

## RELATED LINKS

[Get-TeamViewerAddressBook](Get-TeamViewerAddressBook.md)
