---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version:
schema: 2.0.0
---

# Test-TeamViewerConnectivity

## SYNOPSIS

Test if the TeamViewer network is reachable from this machine.

## SYNTAX

```powershell
Test-TeamViewerConnectivity [-Quiet] [<CommonParameters>]
```

## DESCRIPTION

The command attempts to connect to the external TeamViewer endpoints that are
required to be reachable by the TeamViewer client.
Use this command to troubleshoot possible connection related issues.

## EXAMPLES

### Example 1

```powershell
PS /> Test-TeamViewerConnectivity -Verbose
```

## PARAMETERS

### -Quiet

Suppress any output and only return `True` or `False` depending on the overall
outcome of the connection test.

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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

## NOTES

## RELATED LINKS
