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

### -Id

The unique identifier of the custom field definition. Alias: FieldKeyId.

### -FieldKey

The name of the custom field.

### -Description

An optional description of the custom field.

## EXAMPLES

### Example 1

```powershell
Set-TeamViewerDeviceCustomFieldConfiguration -ApiToken $apiToken -Id $fieldId -FieldKey 'AssetTag'
```

Updates the custom field identified by `$fieldId` and sets its key to `AssetTag`.

## OUTPUTS

### TeamViewerPS.DeviceCustomFieldConfiguration

Returns the updated device custom field definition.
