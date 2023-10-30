---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/Docs/Help/Set-TeamViewerAPIUri.md
schema: 2.0.0
---

# Set-TeamViewerAPIUri

## SYNOPSIS

Change TeamViewer WebAPI Uri.

## SYNTAX

```powershell
Set-TeamViewerAPIUri [-NewUri <String>] 
```

## DESCRIPTION

Changes the WebAPI Uri for internal testing.

## EXAMPLES

### Example 1

```powershell
PS /> Set-TeamViewerAPIUri -NewUri 'www.example.com'
```

Change the WebAPI Uri.

### Example 2

```powershell
PS /> Set-TeamViewerAPIUri -Default $true
```

Sets the WebAPI Uri to default.

## PARAMETERS

### -NewUri

New WebAPI Uri for the module. 

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

Default Web API Uri.

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
