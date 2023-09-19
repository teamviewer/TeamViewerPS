---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/docs/Cmdlets_help/Set-TeamViewerUser.md
schema: 2.0.0
---

# Set-TeamViewerUser

## SYNOPSIS

Change properties of a TeamViewer company user.

## SYNTAX

### ByParameters (Default)

```powershell
Set-TeamViewerUser -ApiToken <SecureString> -User <Object> [-Active <Boolean>] [-Email <String>]
 [-Name <String>] [-Password <SecureString>] [-SsoCustomerIdentifier <SecureString>] [-Permissions <Array>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

### ByProperties

```powershell 
Set-TeamViewerUser -ApiToken <SecureString> -User <Object> -Property <Hashtable> [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION

Changes information for a selected user.

## EXAMPLES

### Example 1

```powershell
PS /> Set-TeamViewerUser -User 'u1234' -Name 'New user name'
```

Change the name of a user.

### Example 2

```powershell
PS /> Set-TeamViewerUser -User 'u1234' -Password (Read-Host -AsSecureString) -Email 'test@example.test'
```

Change email address and password of a user.

### Example 3

```powershell
PS /> $props = @{active = $false}
PS /> Set-TeamViewerUser -User 'u1234' -Property $props 
```

Deactivate a user using a properties hashtable.

### Example 4

```powershell
PS /> $ssoCustomerIdentifier = ("abc" | ConvertTo-SecureString -AsPlainText -Force)
PS /> Set-TeamViewerUser -UserId 'u1234' -SsoCustomerIdentifier $ssoCustomerIdentifier
```

Do the SSO activation step for the given user. This can also be used to repair a possibly broken
SSO login token for that user.

## PARAMETERS

### -Active

Activates (`$true`) or deactivates (`$false`) the company user.

```yaml
Type: Boolean
Parameter Sets: ByParameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ApiToken

The TeamViewer API access token.

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

### -Email

Updated email address of the user.

```yaml
Type: String
Parameter Sets: ByParameters
Aliases: EmailAddress

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name

Updated name of the user.

```yaml
Type: String
Parameter Sets: ByParameters
Aliases: DisplayName

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Password

New password of the user (as secure string).

```yaml
Type: SecureString
Parameter Sets: ByParameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Permissions

Updated set of permissions of the company user.
Please see the TeamViewer API documentation for a list of valid values.

```yaml
Type: Array
Parameter Sets: ByParameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Property

Change policy information using a hashtable object.
Valid hashtable keys are:
`active`, `email`, `name`, `password`, `sso_customer_id`, `permissions`

```yaml
Type: Hashtable
Parameter Sets: ByProperties
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SsoCustomerIdentifier

Optional TeamViewer SSO customer identifier. If given, the user will be updated
with SSO activation step already done. With this option, the user must not
enter the TeamViewer password at when doing Single Sign-On.

```yaml
Type: SecureString
Parameter Sets: ByParameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -User

Object that can be used to identify the user.
This can either be the user ID or a user object that has been received using
other module functions.

```yaml
Type: Object
Parameter Sets: (All)
Aliases: Id, UserId

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf

Shows what would happen if the cmdlet runs.
The cmdlet is not run.

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

### None

## OUTPUTS

## NOTES

## RELATED LINKS
