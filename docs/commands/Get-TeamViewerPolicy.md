---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/docs/commands/Get-TeamViewerPolicy.md
schema: 2.0.0
---

# Get-TeamViewerPolicy

## SYNOPSIS

Retrieve policies created by the account.

## SYNTAX

### FilteredList (Default)

```powershell
Get-TeamViewerPolicy -ApiToken <SecureString> [<CommonParameters>]
```

### ByPolicyId

```powershell
Get-TeamViewerPolicy -ApiToken <SecureString> [-Id <Guid>] [<CommonParameters>]
```

## DESCRIPTION

Retrieve a list of policies or a single policy entry.

## EXAMPLES

### Example 1

```powershell
PS /> Get-TeamViewerPolicy
```

List all policies of this account.

### Example 2

```powershell
PS /> Get-TeamViewerPolicy -Id '730ee15a-1ea4-4d80-9cfe-5a01709d0a2f'
```

Retrieve a single policy entry with the given ID.

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

### -Id

Optional policy ID to retrieve a single policy entry.

```yaml
Type: Guid
Parameter Sets: ByPolicyId
Aliases: PolicyId

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
