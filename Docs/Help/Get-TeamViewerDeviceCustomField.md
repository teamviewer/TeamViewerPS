---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/Docs/Help/Get-TeamViewerDeviceCustomField.md
schema: 2.0.0
---

# Get-TeamViewerDeviceCustomField

## SYNOPSIS

Retrieves the custom field values set for a managed device.

## SYNTAX

```powershell
Get-TeamViewerDeviceCustomField [-ApiToken] <SecureString> [-ManagedDeviceId] <Object> [<CommonParameters>]
```

## DESCRIPTION

Retrieves all custom field values associated with a specific managed device. These are the values assigned to the custom field definitions, not the definitions themselves.

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

## EXAMPLES

### Example 1

```powershell
Get-TeamViewerDeviceCustomField -ApiToken $apiToken -ManagedDeviceId 'd12345678'
```

Retrieves all custom field values for the specified managed device.

### Example 2

```powershell
$device | Get-TeamViewerDeviceCustomField -ApiToken $apiToken
```

Retrieves custom field values by piping a managed device object.

## OUTPUTS

### TeamViewerPS.DeviceCustomField

Returns device custom field value objects containing the field key Id and value.
