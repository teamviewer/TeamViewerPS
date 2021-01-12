---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/docs/commands/Invoke-TeamViewerPackageDownload.md
schema: 2.0.0
---

# Invoke-TeamViewerPackageDownload

## SYNOPSIS

Download the TeamViewer installation package.

## SYNTAX

```powershell
Invoke-TeamViewerPackageDownload [[-PackageType] <String>] [[-MajorVersion] <Int32>]
 [[-TargetDirectory] <String>] [-Force] [<CommonParameters>]
```

## DESCRIPTION

Download the TeamViewer installation package for the current platform.

## EXAMPLES

### Example 1

```powershell
PS /> Invoke-TeamViewerPackageDownload
```

### Example 2

```powershell
PS C:\> Invoke-TeamViewerPackageDownload -PackageType QuickSupport
```

## PARAMETERS

### -Force

If set, the command will override existing files without asking for
confirmation.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MajorVersion

Specify the major version of TeamViewer to download the installation package
for. This option is only available on Windows platforms.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PackageType

Specify the type of installation package to download. This option is only
available on Windows platforms.

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: Full, Host, Portable, QuickJoin, QuickSupport

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TargetDirectory

Specify the target directory to download TeamViewer installation files to.
Defaults 

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
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
