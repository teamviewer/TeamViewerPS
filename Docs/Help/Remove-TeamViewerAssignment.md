---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/Docs/Help/Remove-TeamViewerAssignment.md
schema: 2.0.0
---

# Remove-TeamViewerAssignment

## SYNOPSIS

Unassigns the device from its current company.

## SYNTAX

```powershell
Remove-TeamViewerAssignment [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Unassigns the calling device from its company.

## EXAMPLES

### Example 1

```powershell
Remove-TeamViewerAssignment 
```

Unassigns the device from its company.

### Example 2

```powershell
Remove-TeamViewerAssignment -WhatIf
```

Shows what would happen without actually unassigning the device.

### Example 3

```powershell
Remove-TeamViewerAssignment -Confirm:$false
```

Unassigns the device from its company without prompting for confirmation.

## PARAMETERS

### CommonParameters

## INPUTS

### None

## OUTPUTS

## NOTES

## RELATED LINKS
