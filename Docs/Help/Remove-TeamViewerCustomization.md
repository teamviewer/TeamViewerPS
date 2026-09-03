---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/Docs/Help/Remove-TeamViewerCustomization.md
schema: 2.0.0
---

# Remove-TeamViewerCustomization

## SYNOPSIS

Removes the customization from the TeamViewer installation.

## SYNTAX

```powershell
Remove-TeamViewerCustomization [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Removes the existing customization from the TeamViewer installation.
Existing customization should be removed before applying new customization.

## EXAMPLES

### Example 1

```powershell
Remove-TeamViewerCustomization
```

Removes the customization from the local client.

### Example 2

```powershell
Remove-TeamViewerCustomization -WhatIf
```

Shows what would happen without actually removing the customization.

### Example 3

```powershell
Remove-TeamViewerCustomization -Confirm:$false
```

Removes the customization without prompting for confirmation.

## PARAMETERS

### CommonParameters

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
