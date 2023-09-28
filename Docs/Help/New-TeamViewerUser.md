---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/Docs/Help/New-TeamViewerUser.md
schema: 2.0.0
---

# New-TeamViewerUser

## SYNOPSIS

Create a new TeamViewer company user.

## SYNTAX

### WithPassword (Default)

```powershell
New-TeamViewerUser -ApiToken <SecureString> -Email <String> -Name <String> -Password <SecureString>
 [-SsoCustomerIdentifier <SecureString>] [-Permissions <Array>] [-Culture <CultureInfo>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### WithoutPassword

```powershell
New-TeamViewerUser -ApiToken <SecureString> -Email <String> -Name <String> [-WithoutPassword]
 [-SsoCustomerIdentifier <SecureString>] [-Permissions <Array>] [-Culture <CultureInfo>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION

Creates a new user for the company that is associated to the API access token.

## EXAMPLES

### Example 1

```powershell
PS /> New-TeamViewerUser -Email 'test@example.test' -Name 'Test User'
```

Create a new user with the given email address and name. The password will be
prompted.

### Example 2

```powershell
PS /> New-TeamViewerUser -Email 'test@example.test' -Name 'Test User' -WithoutPassword
```

Create a new user with the given email address and name. It will be created
without a password. The user must reset the password through the TeamViewer
web page.

## PARAMETERS

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

### -Culture

Culture used for the welcome email of the new user.

```yaml
Type: CultureInfo
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Email

Email address of the new user.

```yaml
Type: String
Parameter Sets: (All)
Aliases: EmailAddress

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name

Display name of the new user.

```yaml
Type: String
Parameter Sets: (All)
Aliases: DisplayName

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Password

Password of the new user as secure string.

```yaml
Type: SecureString
Parameter Sets: WithPassword
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Permissions

Optional list of permissions to give to the new user.

```yaml
Type: Array
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SsoCustomerIdentifier

Optional TeamViewer SSO customer identifier. If given, the user will be created
with SSO activation step already done. With this option, the new user must not
enter the TeamViewer password at all when doing Single Sign-On.

```yaml
Type: SecureString
Parameter Sets: (All)
Aliases:

Required: False
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

### -WithoutPassword

If given, the new user is created without a password.
The user must request to reset the password on the TeamViewer web page.

```yaml
Type: SwitchParameter
Parameter Sets: WithoutPassword
Aliases: NoPassword

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
