---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/Docs/Help/Add-TeamViewerAssignment.md
schema: 2.0.0
---

# Add-TeamViewerAssignment

## SYNOPSIS

Assigns the device to a company.

## SYNTAX

```powershell
Add-TeamViewerAssignment [-AssignmentId] [-DeviceAlias] [-Retries] 
```

## DESCRIPTION

Assigns the particular device to a company listed in managed devices.
Assignment ID can be obtained from Management console under Design & Deploy.

## EXAMPLES

### Example 1

```powershell
PS /> Add-TeamViewerAssignment -AssignmentId '0001CoABChCiJnyAKf0R7r6'
PS /> Add-TeamViewerAssignment -AssignmentId '0001CoABChCiJnyAKf0R7r6' -DeviceAlias  'Test Device 1' 
PS /> Add-TeamViewerAssignment -AssignmentId '0001CoABChD3RCXwL6IR7pS' -DeviceAlias  'Test Device 2' -Retries 3

```

Assigns the devices with default Hostname or with names `Test Device 1` and `Test Device 2` to a Company with the given assignment id.

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

The assignment is retried in case of temporary errors. There is a waiting time of 1 second between each try.

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
