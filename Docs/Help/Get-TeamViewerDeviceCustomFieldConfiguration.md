---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/Docs/Help/Get-TeamViewerDeviceCustomFieldConfiguration.md
schema: 2.0.0
---

# Get-TeamViewerDeviceCustomFieldConfiguration

## SYNOPSIS

Lists device custom field definitions for the company.

## SYNTAX

```powershell
Get-TeamViewerDeviceCustomFieldConfiguration [-APIToken] <SecureString> [<CommonParameters>]
```

## DESCRIPTION

Lists all device custom field definitions associated with the company represented by the API token.

## PARAMETERS

### -APIToken

The TeamViewer API access token.

```yaml
Type: SecureString
Required: True
```

## EXAMPLES

### Example 1

```powershell
Get-TeamViewerDeviceCustomFieldConfiguration -APIToken $apiToken
```

Lists all device custom fields in the company.

### Example 2

```powershell
Get-TeamViewerDeviceCustomFieldConfiguration | Select-Object -Property Name, Type
```

Lists all device custom field definitions and shows only their `Name` and `Type` properties.

### Example 3

```powershell
Get-TeamViewerDeviceCustomFieldConfiguration | Where-Object { $_.Type -eq 'text' }
```

Lists only the device custom field definitions whose type is `text`.

## OUTPUTS

### TeamViewerPS.DeviceCustomFieldConfiguration

Returns device custom field definition objects.
