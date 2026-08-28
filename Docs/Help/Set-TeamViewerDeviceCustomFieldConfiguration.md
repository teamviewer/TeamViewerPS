---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/Docs/Help/Set-TeamViewerDeviceCustomFieldConfiguration.md
schema: 2.0.0
---

# Set-TeamViewerDeviceCustomFieldConfiguration

## SYNOPSIS

Updates a device custom field definition.

## SYNTAX

```powershell
Set-TeamViewerDeviceCustomFieldConfiguration [-ApiToken] <SecureString> [-Id] <Guid> [-FieldKey] <String> [[-Description] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Updates an existing company-level device custom field definition.

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
Accept pipeline input: False
Accept wildcard characters: False
```

### -FieldKey

The name of the custom field.

```yaml
Type: String
Parameter Sets: (All)
Aliases: None

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description

An optional description of the custom field.

```yaml
Type: String
Parameter Sets: (All)
Aliases: None

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## EXAMPLES

### Example 1

```powershell
Set-TeamViewerDeviceCustomFieldConfiguration -ApiToken $apiToken -Id $fieldId -FieldKey 'AssetTag'
```

Updates the custom field identified by `$fieldId` and sets its key to `AssetTag`.

## OUTPUTS

### TeamViewerPS.DeviceCustomFieldConfiguration

Returns the updated device custom field definition.
