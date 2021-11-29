---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/docs/commands/Get-TeamViewerEventLog.md
schema: 2.0.0
---

# Get-TeamViewerEventLog

## SYNOPSIS

Returns TeamViewer audit log events for the current account's company.

## SYNTAX

### RelativeDates (Default)

```powershell
Get-TeamViewerEventLog -ApiToken <SecureString> [-EndDate <DateTime>] [-Months <Int32>] [-Days <Int32>]
 [-Hours <Int32>] [-Minutes <Int32>] [-Limit <Int32>] [-EventNames <String[]>] [-EventTypes <String[]>]
 [-AccountEmails <Object[]>] [-AffectedItem <String>] [-RemoteControlSessionId <Guid>] [<CommonParameters>]
```

### AbsoluteDates

```powershell
Get-TeamViewerEventLog -ApiToken <SecureString> -StartDate <DateTime> [-EndDate <DateTime>] [-Limit <Int32>]
 [-EventNames <String[]>] [-EventTypes <String[]>] [-AccountEmails <Object[]>] [-AffectedItem <String>]
 [-RemoteControlSessionId <Guid>] [<CommonParameters>]
```

## DESCRIPTION

Fetches audit log events for the TeamViewer company that is associated with the
given TeamViewer Web API token.

The list can optionally be filtered.

## EXAMPLES

### Example 1

```powershell
PS /> Get-TeamViewerEventLog
```

Gets all audit log events of the current company that were created in the last
hour.

### Example 2

```powershell
PS /> Get-TeamViewerEventLog -Days 7
```

Gets all audit log events of the current company that were created in the last
seven days.

### Example 3

```powershell
PS /> Get-TeamViewerEventLog -StartDate "2021-10-01" -EventNames "UserCreated","UserDeleted"
```

Gets user creation & deletion audit log events of the current company that were
created since October 1st, 2021.

## PARAMETERS

### -AccountEmails

Optionally filter for events that are created by the accounts with the given
email addresses.

```yaml
Type: Object[]
Parameter Sets: (All)
Aliases: Users

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AffectedItem

Optionally filter for events that affect the given item.

```yaml
Type: String
Parameter Sets: (All)
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

### -Days

Sets the start date to the given number of days before the end date.
If no `-EndDate` is given, this is the number of days in the past until now.

```yaml
Type: Int32
Parameter Sets: RelativeDates
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EndDate

Sets the end for the date range of events to fetch. Defaults to now.

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Now
Accept pipeline input: False
Accept wildcard characters: False
```

### -EventNames

Optionally filter for audit events with specific names. For example only list
`UserCreated` events that are written when user accounts are created in the
company. Multiple values can be specified, separated by comma.

Possible values are:

- `AddRemoteWorkerDevice`
- `ChangedDisabledRemoteInput`
- `ChangedShowBlackScreen`
- `CompanyAddressBookDisabled`
- `CompanyAddressBookEnabled`
- `CompanyAddressBookMembersHid`
- `CompanyAddressBookMembersUnhid`
- `ConditionalAccessBlockMeetingStateChanged`
- `ConditionalAccessDirectoryGroupAdded`
- `ConditionalAccessDirectoryGroupDeleted`
- `ConditionalAccessDirectoryGroupMembersAdded`
- `ConditionalAccessDirectoryGroupMembersDeleted`
- `ConditionalAccessRuleAdded`
- `ConditionalAccessRuleDeleted`
- `ConditionalAccessRuleModified`
- `ConditionalAccessRuleVerificationStateChanged`
- `CreateCustomHost`
- `DeleteCustomHost`
- `EditOwnProfile`
- `EditTFAUsage`
- `EditUserPermissions`
- `EditUserProperties`
- `EmailConfirmed`
- `EndedRecording`
- `EndedSession`
- `GroupAdded`
- `GroupDeleted`
- `GroupShared`
- `GroupUpdated`
- `IncomingSession`
- `JoinCompany`
- `JoinedSession`
- `LeftSession`
- `ParticipantJoinedSession`
- `ParticipantLeftSession`
- `PausedRecording`
- `PolicyAdded`
- `PolicyDeleted`
- `PolicyUpdated`
- `ReceivedDisabledLocalInput`
- `ReceivedFile`
- `ReceivedShowBlackScreen`
- `RemoveRemoteWorkerDevice`
- `ResumedRecording`
- `ScriptTokenAdded`
- `ScriptTokenDeleted`
- `ScriptTokenUpdated`
- `SentFile`
- `StartedRecording`
- `StartedSession`
- `SwitchedSides`
- `UpdateCustomHost`
- `UserCreated`
- `UserDeleted`
- `UserGroupCreated`
- `UserGroupDeleted`
- `UserGroupMembersAdded`
- `UserGroupMembersRemoved`
- `UserGroupUpdated`
- `UserRemovedFromCompany`

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EventTypes

Optionally filter for audit events with specific types. For example only list
`LicenseManagement` events that concern license-related topics.
Multiple values can be specified, separated by comma.

Possible values are:

- `CompanyAddressBook`
- `CompanyAdministration`
- `ConditionalAccess`
- `CustomModules`
- `GroupManagement`
- `LicenseManagement`
- `Policy`
- `Session`
- `UserGroups`
- `UserProfile`

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Hours

Sets the start date to the given number of hours before the end date.
If no `-EndDate` is given, this is the number of hours in the past until now.

```yaml
Type: Int32
Parameter Sets: RelativeDates
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Limit

Optionally limit the results to the given number. If the limit is reached the
function stops and won't fetch more events.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Minutes

Sets the start date to the given number of minutes before the end date.
If no `-EndDate` is given, this is the number of minutes in the past until now.

```yaml
Type: Int32
Parameter Sets: RelativeDates
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Months

Sets the start date to the given number of months before the end date.
If no `-EndDate` is given, this is the number of months in the past until now.

```yaml
Type: Int32
Parameter Sets: RelativeDates
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RemoteControlSessionId

Optionally filter for a specific remote control session.

```yaml
Type: Guid
Parameter Sets: (All)
Aliases: RemoteControlSession

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -StartDate

Sets the start for the date range of events to fetch.

```yaml
Type: DateTime
Parameter Sets: AbsoluteDates
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
