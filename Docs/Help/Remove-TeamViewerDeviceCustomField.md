---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/Docs/Help/Remove-TeamViewerDeviceCustomField.md
schema: 2.0.0
---

# Remove-TeamViewerDeviceCustomField

## SYNOPSIS

Deletes a device custom field definition.

## SYNTAX

```powershell
Remove-TeamViewerDeviceCustomField [-ApiToken] <SecureString> [-Id] <Guid> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Deletes a company-level device custom field definition. Deleting a definition also removes values stored for this field on devices.

## PARAMETERS

### -ApiToken

The TeamViewer API access token.

### -Id

The unique identifier of the custom field definition. Alias: FieldKeyId.

## EXAMPLES

```powershell
Remove-TeamViewerDeviceCustomField -ApiToken $apiToken -Id $fieldId
```
