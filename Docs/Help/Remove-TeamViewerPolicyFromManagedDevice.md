---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: [Link to Online Documentation]
schema: 2.0.0
---

# Remove-TeamViewerPolicyFromManagedDevice

## SYNOPSIS

Remove a policy from a managed device based on type.

Valid Types are:

- TeamViewer
- Monitoring
- PatchManagement

## SYNTAX

```powershell
Remove-TeamViewerPolicyFromManagedDevice -ApiToken <SecureString> -Device <Object> -PolicyType <PolicyType> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Remove a specified policy from a managed device.

## EXAMPLES

### Example 1

Remove TeamViewer policy from device

```powershell
PS /> Remove-TeamViewerPolicyFromManagedDevice -Device 'd8773208-a685-4323-9de5-7f86951f8c30' -PolicyType 1
```

```powershell
PS /> Remove-TeamViewerPolicyFromManagedDevice -Device 'd8773208-a685-4323-9de5-7f86951f8c30' -PolicyType TeamViewer
```

### Example 2

Remove Monitoring policy from device

```powershell
PS /> Remove-TeamViewerPolicyFromManagedDevice -Device '730ee15a-1ea4-4d80-9cfe-5a01709d0a2f' -PolicyType 4
```

```powershell
PS /> Remove-TeamViewerPolicyFromManagedDevice -Device '730ee15a-1ea4-4d80-9cfe-5a01709d0a2f' -PolicyType Monitoring
```

### Example 3

Remove PatchManagement policy from device

```powershell
PS /> Remove-TeamViewerPolicyFromManagedDevice -Device '730ee15a-1ea4-4d80-9cfe-5a01709d0a2f' -PolicyType 5
```

```powershell
PS /> Remove-TeamViewerPolicyFromManagedDevice -Device '730ee15a-1ea4-4d80-9cfe-5a01709d0a2f' -PolicyType PatchManagement
```

## PARAMETERS

### -ApiToken

The TeamViewer API access token.

```yaml
Type: SecureString
Parameter Sets: (All)
Aliases:
Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Device

The managed device from which you want to remove the policy.

```yaml
Type: Object
Parameter Sets: (All)
Aliases: DeviceId
Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -PolicyType

The type of policy to remove from the managed device.

```yaml
Type: PolicyType (Enum)
Parameter Sets: (All)
Aliases:
Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm

Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf
Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf

Shows what would happen if the cmdlet runs. The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi
Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Object

## OUTPUTS

## NOTES

## RELATED LINKS
