---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/Docs/Help/New-TeamViewerGroup.md
schema: 2.0.0
---

# New-TeamViewerGroup

## SYNOPSIS

Create a new group in the TeamViewer Computer & Contacts list.

## SYNTAX

```powershell
New-TeamViewerGroup [-ApiToken] <SecureString> [-Name] <String> [[-Policy] <Object>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION

Create a new group in the account's Computer & Contacts list.

## EXAMPLES

### Example 1

```powershell
New-TeamViewerGroup -Name 'Test Group'
```

Create a new group with the given name.

### Example 2

```powershell
New-TeamViewerGroup -Name 'Servers' -Policy 'c0cb303a-8a85-4e54-b657-a4757c791aef'
```

Creates a new group and assigns the policy with the given policy Id to it.

### Example 3

```powershell
$policy = Get-TeamViewerPolicy -PolicyId 'c0cb303a-8a85-4e54-b657-a4757c791aef'

New-TeamViewerGroup -Name 'Workstations' -Policy $policy
```

Creates a new group and assigns a policy object retrieved with `Get-TeamViewerPolicy`.

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

### -Name

Name of the new group.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Policy

Optional object that can be used to identify the policy.
This can either be the policy Id or a policy object that has been received using other module functions.
If given, the policy will be assigned to the group.

```yaml
Type: Object
Parameter Sets: (All)
Aliases: PolicyId

Required: False
Position: 2
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
