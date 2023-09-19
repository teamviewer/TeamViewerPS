---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/docs/Cmdlets_help/Get-TeamViewerManager.md
schema: 2.0.0
---

# Get-TeamViewerManager

## SYNOPSIS

Retrieves managers of TeamViewer managed devices or managed groups.

## SYNTAX

### ByDeviceId (Default)

```powershell
Get-TeamViewerManager -ApiToken <SecureString> -Device <Object> [<CommonParameters>]
```

### ByGroupId

```powershell
Get-TeamViewerManager -ApiToken <SecureString> -Group <Object> [<CommonParameters>]
```

## DESCRIPTION

Retrieves the list of managers of a managed device or a managed group.

## EXAMPLES

### Example 1

```powershell
PS /> Get-TeamViewerManager -Device 'c0cb303a-8a85-4e54-b657-a4757c791aef'
```

List the managers of the managed device with the given ID.

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

### -Device

Object that can be used to identify the managed device.
This can either be the managed device ID (as string or GUID) or a managed device
object that has been received using other module functions.

```yaml
Type: Object
Parameter Sets: ByDeviceId
Aliases: DeviceId

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Group

Object that can be used to identify the managed group.
This can either be the managed group ID (as string or GUID) or a managed group
object that has been received using other module functions.

```yaml
Type: Object
Parameter Sets: ByGroupId
Aliases: GroupId

Required: True
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
