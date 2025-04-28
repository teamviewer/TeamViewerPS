---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/Docs/Help/Get-TeamViewerCompanyManagedDevice.md
schema: 2.0.0
---

# Get-TeamViewerCompanyManagedDevice

## SYNOPSIS

Retrieves TeamViewer company-managed devices. Requires an API Token with 'company admin' and 'Device Groups: read operations' permissions.

## SYNTAX

### List (Default)

```powershell
Get-TeamViewerCompanyManagedDevice -ApiToken <SecureString> [<CommonParameters>]
```

## DESCRIPTION

Retrieves company-managed devices of the company that is associated with the API access token.

## EXAMPLES

### Example 1

```powershell

PS /> Get-TeamViewerCompanyManagedDevice
```

List all company-managed devices of this company.

## PARAMETERS

### -ApiToken

The TeamViewer API access token. Needs to have 'company admin' and 'Device Groups: read operations' permissions to successfully retrieve the devices.

```yaml
Type: SecureString
Parameter Sets: (All)
Aliases:

Required: True
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

[Get-TeamViewerManagedDevice](Get-TeamViewerManagedDevice.md)

[Get-TeamViewerManagedGroup](Get-TeamViewerManagedGroup.md)

[Get-TeamViewerManagementId](Get-TeamViewerManagementId.md)
