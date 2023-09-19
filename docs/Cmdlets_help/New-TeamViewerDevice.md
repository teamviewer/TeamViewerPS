---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/docs/Cmdlets_help/New-TeamViewerDevice.md
schema: 2.0.0
---

# New-TeamViewerDevice

## SYNOPSIS

Create a new device entry in the TeamViewer Computers & Contacts list.

## SYNTAX

```powershell
New-TeamViewerDevice [-ApiToken] <SecureString> [-TeamViewerId] <Int32> [-Group] <Object> [[-Name] <String>]
 [[-Description] <String>] [[-Password] <SecureString>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Adds a new device entry to the Computers & Contacts list of the account that is
associated to the TeamViewer API access token. 

## EXAMPLES

### Example 1

```powershell
PS /> New-TeamViewerDevice -TeamViewerId 12345678 -Group 'g1234'
```

Adds the device with the given TeamViewer ID to the Computers & Contacts list
into the group with the given group ID.

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

### -Description

Optional description for the device entry.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Group

Object that can be used to identify the group.
This can either be the group ID or a group object that has been received using
other module functions.

```yaml
Type: Object
Parameter Sets: (All)
Aliases: GroupId

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name

Optional alias for the device entry.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Alias

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Password

Optional password that will be used when connecting to the device with the
TeamViewer desktop client.

```yaml
Type: SecureString
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TeamViewerId

The TeamViewer remote control ID of the device to be added.

```yaml
Type: Int32
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

## OUTPUTS

## NOTES

## RELATED LINKS
