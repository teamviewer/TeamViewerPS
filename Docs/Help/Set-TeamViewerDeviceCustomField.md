---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/Docs/Help/Set-TeamViewerDeviceCustomField.md
schema: 2.0.0
---

# Set-TeamViewerDeviceCustomField

## SYNOPSIS

Sets or updates a custom field value for a managed device.

## SYNTAX

```powershell
Set-TeamViewerDeviceCustomField [-ApiToken] <SecureString> [-ManagedDeviceId] <Object> [-FieldConfigurationId] <Guid> [-Value] <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Sets or updates the value of a custom field for a specific managed device. If the device already has a value for the specified custom field, the existing value is overwritten.

## PARAMETERS

### -ApiToken

The TeamViewer API access token.

```yaml
Type: SecureString
Required: True
```

### -ManagedDeviceId

The unique identifier of the managed device. Can be a device Id string or a TeamViewerPS.ManagedDevice object.

```yaml
Type: Object
Aliases: ManagedDevice, Device, DeviceId
Required: True
```

### -FieldConfigurationId

The unique identifier of the custom field definition (FieldKeyId).

```yaml
Type: Guid
Aliases: FieldKeyId
Required: True
```

### -Value

The value to set for the custom field.

```yaml
Type: String
Required: True
```

## EXAMPLES

### Example 1

```powershell
Set-TeamViewerDeviceCustomField -ApiToken $apiToken -ManagedDeviceId 'd12345678' -FieldConfigurationId '00000000-0000-0000-0000-000000000001' -Value 'AssetTag001'
```

Sets the value of a custom field for the specified managed device.

### Example 2

```powershell
Set-TeamViewerDeviceCustomField -DeviceId 'd12345678' -FieldKeyId 'c0cb303a-8a85-4e54-b657-a4757c791aef' -Value 'Building A'
```

Uses the `DeviceId` and `FieldKeyId` aliases to set a custom field value on the managed device.

### Example 3

```powershell
Get-TeamViewerManagedDevice -Name 'Server01' | Set-TeamViewerDeviceCustomField -FieldConfigurationId 'c0cb303a-8a85-4e54-b657-a4757c791aef' -Value 'Rack 12'
```

Sets a custom field value on the managed device object retrieved via `Get-TeamViewerManagedDevice`.

## OUTPUTS

### TeamViewerPS.DeviceCustomField

Returns the updated device custom field value object.
