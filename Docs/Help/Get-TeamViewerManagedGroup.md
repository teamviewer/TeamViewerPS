---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/Docs/Help/Get-TeamViewerManagedGroup.md
schema: 2.0.0
---

# Get-TeamViewerManagedGroup

## SYNOPSIS

Retrieves TeamViewer managed groups.

## SYNTAX

### List (Default)

```powershell
Get-TeamViewerManagedGroup -ApiToken <SecureString> [<CommonParameters>]
```

### ByGroupId

```powershell
Get-TeamViewerManagedGroup -ApiToken <SecureString> [-Id <Guid>] [<CommonParameters>]
```

### ByDeviceId

```powershell
Get-TeamViewerManagedGroup -ApiToken <SecureString> [-Device <Object>] [<CommonParameters>]
```

## DESCRIPTION

Retrieves managed groups of the manager that is associated with the API access token.

## EXAMPLES

### Example 1

```powershell
Get-TeamViewerManagedGroup
```

List all managed groups of this manager.

### Example 2

```powershell
Get-TeamViewerManagedGroup -Id '9fd16af0-c224-4242-998e-a7138b038dbb'
```

Retrieve a single managed group entry for the group with the given Id.

### Example 3

```powershell
Get-TeamViewerManagedGroup -Device 'c0cb303a-8a85-4e54-b657-a4757c791aef'
```

List the managed groups that the managed device with the given Id is part of.

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

Object that can be used to identify a managed device.
This can either be the managed device Id (as string or GUID) or a managed device object that has been received using other module functions.
If given, this command returns the list of managed groups that the device is part of.

```yaml
Type: Object
Parameter Sets: ByDeviceId
Aliases: DeviceId

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Id

Optional managed group Id. If given, the command retrieves a single managed group entry with this Id.

```yaml
Type: Guid
Parameter Sets: ByGroupId
Aliases: GroupId

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
