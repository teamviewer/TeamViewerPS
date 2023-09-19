---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version:
schema: 2.0.0
---

# Export-TeamViewerSystemInformation

## SYNOPSIS

Collect the files required by TeamViewer support and zip them.

## SYNTAX

```powershell
Export-TeamViewerSystemInformation [[-TargetDirectory] <String>] [<CommonParameters>]
```

## DESCRIPTION

Collects the files required by TeamViewer support and creates a zip file with clientID in its name.

## EXAMPLES

### Example 1

```powershell
PS /> Export-TeamViewerSystemInformation
```

The zip file is created and stored in the working directory.

### Example 2

```powershell
PS C:\> Export-TeamViewerSystemInformation -TargetDirectory "C:\"
```

The zip file is created and stored in the target directory

## PARAMETERS

### -TargetDirectory

Specify the target directory to store TeamViewer support file.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

## NOTES

## RELATED LINKS
