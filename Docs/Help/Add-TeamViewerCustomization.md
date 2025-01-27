---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/Docs/Help/Add-TeamViewerCustomization.md
schema: 2.0.0
---

# Add-TeamViewerCustomization

## SYNOPSIS

Adds a customization (custom module) to the local TeamViewer client.

## SYNTAX

```powershell
Add-TeamViewerCustomization [[-Id] || [-Path]] [-RestartGUI] [-RemoveExisting]
```

## DESCRIPTION

Adds a customization (custom module) to the local TeamViewer client..
Customization can be perfomed in Management console under Design & Deploy.

## EXAMPLES

### Example 1

```powershell
PS /> Add-TeamViewerCustomization -Id '1234567'
PS /> Add-TeamViewerCustomization -Id '1234567' -RestartGUI
PS /> Add-TeamViewerCustomization -Id '1234567' -RestartGUI -RemoveExisting

```

Customizes the TeamViewer installation with Id.
The next customization to be applied can already be specified after the existing customization removal is performed.
The RestartGUI restarts the running TeamViewer client and the visual changes are applied.

### Example 2

```powershell
PS /> Add-TeamViewerCustomization -Path  "X:\67byysp.zip"
PS /> Add-TeamViewerCustomization -Path  "X:\67byysp.zip" -RestartGUI
PS /> Add-TeamViewerCustomization -Path  "X:\67byysp.zip" -RestartGUI -RemoveExisting

```

Customizes the TeamViewer installation with zip file.
The next customization to be applied can already be specified after the existing customization removal is performed.
The RestartGUI restarts the running TeamViewer client and the visual changes are applied.

## PARAMETERS

### -Id

Object that is required to customize the TeamViewerInstallation.

```yaml
Type: Object
Parameter Sets: (All)
Aliases: None

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Path

Object to the path of the customization zip file can be specified instead of Id.

```yaml
Type: object
Parameter Sets: (All)
Aliases: None

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RestartGUI

Switch to restart the running TeamViewer client to visualize changes.

```yaml
Type: switch
Parameter Sets: (All)
Aliases: None

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RemoveExisting

Switch to specify the next customization to be applied after the existing customization is removed.

```yaml
Type: switch
Parameter Sets: (All)
Aliases: None

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

### None

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
