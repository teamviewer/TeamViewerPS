---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/docs/commands/Remove-TeamViewerDevice.md
schema: 2.0.0
---

# Remove-TeamViewerDevice

## SYNOPSIS

Delete a device from the Computers & Contacts list.

## SYNTAX

```powershell
Remove-TeamViewerDevice [-ApiToken] <SecureString> [-Device] <Object> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Deletes a device from the Computers & Contacts list of the account associated to
the API access token.

## EXAMPLES

### Example 1

```powershell
PS /> Remove-TeamViewerDevice -Device 'd1234'
```

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

### -Device

Object that can be used to identify the device entry.
This can either be the device ID or a device object that has been received
using other module functions.

```yaml
Type: Object
Parameter Sets: (All)
Aliases: Id, DeviceId

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
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

## OUTPUTS

## NOTES

## RELATED LINKS
