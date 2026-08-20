---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/Docs/Help/Remove-TeamViewerDeviceCustomField.md
schema: 2.0.0
---

# Remove-TeamViewerDeviceCustomField

## SYNOPSIS

Deletes a custom field value from a managed device.

## SYNTAX

```powershell
Remove-TeamViewerDeviceCustomField [-ApiToken] <SecureString> [-ManagedDeviceId] <Object> [-FieldConfigurationId] <Guid> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Removes a custom field value from a specific managed device. The custom field definition remains intact and can be reassigned with a new value.

## PARAMETERS

### -ApiToken

The TeamViewer API access token.

```yaml
Type: SecureString
Required: True
```

### -ManagedDeviceId

The unique identifier of the managed device. Can be a device ID string or a TeamViewerPS.ManagedDevice object.

```yaml
Type: Object
Aliases: DeviceId
Required: True
```

### -FieldConfigurationId

The unique identifier of the custom field definition (FieldKeyId).

```yaml
Type: Guid
Aliases: FieldKeyId
Required: True
```

## EXAMPLES

### Example 1

```powershell
Remove-TeamViewerDeviceCustomField -ApiToken $apiToken -ManagedDeviceId 'd12345678' -FieldConfigurationId '00000000-0000-0000-0000-000000000001'
```

Removes the custom field value from the specified managed device.

## OUTPUTS

### None

This cmdlet does not return output.
