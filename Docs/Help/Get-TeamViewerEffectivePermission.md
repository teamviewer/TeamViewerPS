---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/Docs/Help/Get-TeamViewerEffectivePermission.md
schema: 2.0.0
---
 
# Get-TeamViewerEffectivePermission
 
## SYNOPSIS
 
Lists all effective permissions in a TeamViewer company.
 
## SYNTAX
 
```powershell
Get-TeamViewerEffectivePermission [-ApiToken] <SecureString> [<CommonParameters>]
```
 
## DESCRIPTION
 
Lists all effective permissions in the TeamViewer company associated with the API access token.
 
## EXAMPLES
 
### Example 1
 
```powershell
Get-TeamViewerEffectivePermission
```
 
Lists all effective permissions.
 
### Example 2
 
```powershell
$permissions = Get-TeamViewerEffectivePermission
```
 
Retrieves the effective permissions and stores them in a variable for later inspection.
 
### Example 3
 
```powershell
(Get-TeamViewerEffectivePermission).PSObject.Properties | Where-Object { $_.Value -eq $true }
```
 
Lists only the effective permissions that are currently enabled.
 
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
 
### CommonParameters
 
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).
 
## INPUTS
 
### None
 
## OUTPUTS
 
### System.Object

## NOTES
 
## RELATED LINKS
