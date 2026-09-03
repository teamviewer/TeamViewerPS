---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/Docs/Help/New-TeamViewerDeviceCustomFieldConfiguration.md
schema: 2.0.0
---

# New-TeamViewerDeviceCustomFieldConfiguration

## SYNOPSIS

Creates a device custom field definition for the company.

## SYNTAX

```powershell
New-TeamViewerDeviceCustomFieldConfiguration [-ApiToken] <SecureString> [-FieldKey] <String> [[-Description] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Creates a company-level device custom field definition. The API supports up to 50 definitions per company.

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

### -FieldKey

The name of the custom field.

```yaml
Type: String
Parameter Sets: (All)
Aliases: None

Required: True
Position: 1
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
New-TeamViewerDeviceCustomFieldConfiguration -ApiToken $apiToken -FieldKey 'AssetTag' -Description 'Device asset tag'
```

Creates an `AssetTag` device custom field with a description.

## OUTPUTS

### TeamViewerPS.DeviceCustomFieldConfiguration

Returns the created device custom field definition.
