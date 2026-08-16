---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/Docs/Help/Get-TeamViewerDeviceCustomField.md
schema: 2.0.0
---

# Get-TeamViewerDeviceCustomField

## SYNOPSIS

Lists device custom field definitions for the company.

## SYNTAX

```powershell
Get-TeamViewerDeviceCustomField [-ApiToken] <SecureString> [<CommonParameters>]
```

## DESCRIPTION

Lists all device custom field definitions associated with the company represented by the API token.

## PARAMETERS

### -ApiToken

The TeamViewer API access token.

```yaml
Type: SecureString
Required: True
```

## EXAMPLES

### Example 1

```powershell
Get-TeamViewerDeviceCustomField -ApiToken $apiToken
```

Lists all device custom fields in the company.

## OUTPUTS

### TeamViewerPS.DeviceCustomField

Returns device custom field definition objects.
