---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/Docs/Help/Set-TeamViewerAccount.md
schema: 2.0.0
---

# Set-TeamViewerAccount

## SYNOPSIS

Change TeamViewer account information.

## SYNTAX

### ByParameters (Default)

```powershell
Set-TeamViewerAccount -ApiToken <SecureString> [-Name <String>] [-Email <String>] [-Password <SecureString>]
 [-OldPassword <SecureString>] [-EmailLanguage <Object>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### ByProperties

```powershell
Set-TeamViewerAccount -ApiToken <SecureString> -Property <Hashtable> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Changes account information of the TeamViewer account associated with the API
access token.

## EXAMPLES

### Example 1

```powershell
PS /> Set-TeamViewerAccount -Name 'Another New Name'
```

Change the account name.

### Example 2

```powershell
PS /> Set-TeamViewerAccount -Email 'test@example.test'
```

Change the account email address.

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

### -Email

New email address for the account. Please note that changing the email address
needs to be confirmed in the Management Console before changes take effect.

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

### -EmailLanguage

Allows to set the language of the email conversation for this account.

```yaml
Type: Object
Parameter Sets: ByParameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name

Updated name of the account.

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

### -OldPassword

The current password of the account. Required when attempting to change the
account password with the `-Password` parameter.

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

### -Password

The new password for the account. This also requires to specify the current
password using the `-OldPassword` parameter.

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

### -Property

Change account information using a hashtable object.
Valid hashtable keys are:
`name`, `email`, `password`, `oldpassword`, `email_language`

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
