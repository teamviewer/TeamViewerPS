---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/Docs/Help/Remove-TeamViewerPSProxy
schema: 2.0.0
---

# Remove-TeamViewerPSProxy

## SYNOPSIS

Remove TeamViewerPS proxy.

## SYNTAX

```powershell
Remove-TeamViewerPSProxy
```

## DESCRIPTION

Removes the proxy and sets it to default for TeamViewerPS module functions.

## EXAMPLES

### Example 1

```powershell
Remove-TeamViewerPSProxy 
```

Removes the existing proxy server used and sets it to default.

### Example 2

```powershell
Remove-TeamViewerPSProxy -WhatIf
```

Shows what would happen without actually removing the proxy configuration.

### Example 3

```powershell
Remove-TeamViewerPSProxy -Confirm:$false
```

Removes the existing proxy server without prompting for confirmation.

## PARAMETERS

### CommonParameters

## INPUTS

### None

## OUTPUTS

## NOTES

## RELATED LINKS
