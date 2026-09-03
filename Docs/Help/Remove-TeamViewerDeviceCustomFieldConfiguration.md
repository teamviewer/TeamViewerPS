---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/Docs/Help/Remove-TeamViewerDeviceCustomFieldConfiguration.md
schema: 2.0.0
---

# Remove-TeamViewerDeviceCustomFieldConfiguration

## SYNOPSIS

Deletes a device custom field definition.

## SYNTAX

```powershell
Remove-TeamViewerDeviceCustomFieldConfiguration [-ApiToken] <SecureString> [-Id] <Guid> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Deletes a company-level device custom field definition. Deleting a definition also removes values stored for this field on devices.

## PARAMETERS

### -ApiToken

The TeamViewer API access token.

```yaml
Type: SecureString
Parameter Sets: (All)
Aliases: None

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Id

The unique identifier of the custom field definition. Alias: FieldKeyId.

```yaml
Type: Guid
Parameter Sets: (All)
Aliases: FieldKeyId

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

## EXAMPLES

### Example 1

```powershell
Remove-TeamViewerDeviceCustomFieldConfiguration -ApiToken $apiToken -Id $fieldId
```

Deletes the device custom field identified by `$fieldId` and its stored device values.

### Example 2

```powershell
Remove-TeamViewerDeviceCustomFieldConfiguration -Id 'c0cb303a-8a85-4e54-b657-a4757c791aef'
```

Deletes the device custom field definition identified by the given Id.

### Example 3

```powershell
'730ee15a-1ea4-4d80-9cfe-5a01709d0a2f' | Remove-TeamViewerDeviceCustomFieldConfiguration
```

Deletes the device custom field definition using pipeline input.

## OUTPUTS

### None

This cmdlet does not return output.
