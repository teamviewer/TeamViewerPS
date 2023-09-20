---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/docs/Cmdlets_help/Remove-TeamViewerUser.md
schema: 2.0.0
---

# Remove-TeamViewerUser

## SYNOPSIS

Removes a user from the TeamViewer tenant

## SYNTAX

```
Remove-TeamViewerUser [-ApiToken] <SecureString> [-User] <Object> [-Permanent] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION

Removes an existing user from the TeamViewer tenant.
If the switch -Permanent is added the user is delete from TeamViewer completely, otherwise it is only removed from the tenant.

## EXAMPLES

### Example 1

```powershell
PS C:\> Remove-TeamViewerUser -User 'u1234'
```


## PARAMETERS

### -ApiToken

The TeamViewer API access token

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

### -Permanent

Deletes the user account completely instead of just removing it from the tenant.

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

### -User

Object that can be used to identify the user.
This can either be the user ID or a user object that has been received using other module functions

```yaml
Type: Object
Parameter Sets: (All)
Aliases: Id, UserId

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
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

### System.Object

## OUTPUTS

## NOTES

## RELATED LINKS
