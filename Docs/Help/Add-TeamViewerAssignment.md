---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/Docs/Help/Add-TeamViewerAssignment.md
schema: 2.0.0
---

# Add-TeamViewerAssignment

## SYNOPSIS

Assigns the local device to a TeamViewer company.

## SYNTAX

```powershell
Add-TeamViewerAssignment [-AssignmentId] [-DeviceAlias] [-Retries] 
```

## DESCRIPTION

Assigns the local / current device to a TeamViewer company where it's listed in "managed devices".
The Assignment Id can be obtained from the Management Console (MCO) under Design & Deploy.

## EXAMPLES

### Example 1

```powershell
Add-TeamViewerAssignment -AssignmentId '0001CoABChCiJnyAKf0R7r6'

```

Assigns the local device with default alias (hostname of device) to the TeamViewer company corresponding to the Assignment Id.

### Example 2

```powershell
Add-TeamViewerAssignment -AssignmentId '0001CoABChD3RCXwL6IR7pS' -DeviceAlias  'My Test Device' -Retries 3

```

Assigns the local device with alias "My Test Device" to the corresponding TeamViewer company.
Three assignment retries are done.

## PARAMETERS

### -AssignmentId

Object that is required to assign the device to a Company.

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

### -DeviceAlias

The alias for a device that is set. If omitted the host-name is used.

```yaml
Type: String
Parameter Sets: (All)
Aliases: None

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Retries

The assignment is retried in case of temporary connection errors. There is a waiting time of 1 second between each try.

```yaml
Type: int
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
