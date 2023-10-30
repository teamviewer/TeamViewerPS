---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/Docs/Help/Set-TeamViewerAPIUri.md
schema: 2.0.0
---

# Set-TeamViewerAPIUri

## SYNOPSIS

Change uri of the TeamViewer web API for TeamViewerPS.

## SYNTAX

```powershell
Set-TeamViewerAPIUri [-NewUri <String>] 
```

## DESCRIPTION

Change uri of TeamViewer web API for TeamViewer internal testing purposes.

## EXAMPLES

### Example 1

```powershell
PS /> Set-TeamViewerAPIUri -NewUri 'www.example.com'
```

Sets the uri of the web API to `www.example.com`.

### Example 2

```powershell
PS /> Set-TeamViewerAPIUri -Default $true
```

Sets the WebAPI for TeamViewerPS to the default value.

## PARAMETERS

### -NewUri

Sets a specific uri to the web API for TeamViewerPS. 

```yaml
Type: String
Parameter Sets: None
Aliases: None

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Default

Sets the web API for TeamViewerPS to the default value.

```yaml
Type: Bool
Parameter Sets: None
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

### None

## OUTPUTS

## NOTES

## RELATED LINKS
