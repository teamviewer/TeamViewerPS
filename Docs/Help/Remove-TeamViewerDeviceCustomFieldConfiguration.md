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

## OUTPUTS

### None

This cmdlet does not return output.
