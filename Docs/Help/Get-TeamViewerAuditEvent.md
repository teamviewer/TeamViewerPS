---
external help file: TeamViewerPS-help.xml
Module Name: TeamViewerPS
online version: https://github.com/teamviewer/TeamViewerPS/blob/main/Docs/Help/Get-TeamViewerEventLog.md
schema: 2.0.0
---

# Get-TeamViewerEventLog

## SYNOPSIS

Returns TeamViewer audit log events for the current account's company.

## SYNTAX

### RelativeDates (Default)

```powershell
Get-TeamViewerEventLog -APIToken <SecureString> [-EndDate <DateTime>] [-Months <Int32>] [-Days <Int32>]
 [-Hours <Int32>] [-Minutes <Int32>] [-Limit <Int32>] [-EventNames <String[]>] [-EventTypes <String[]>]
 [-AccountEmails <Object[]>] [-AffectedItem <String>] [-RemoteControlSessionId <Guid>] [<CommonParameters>]
```

### AbsoluteDates

```powershell
Get-TeamViewerEventLog -APIToken <SecureString> -StartDate <DateTime> [-EndDate <DateTime>] [-Limit <Int32>]
 [-EventNames <String[]>] [-EventTypes <String[]>] [-AccountEmails <Object[]>] [-AffectedItem <String>]
 [-RemoteControlSessionId <Guid>] [<CommonParameters>]
```

## DESCRIPTION

Fetches audit log events for the TeamViewer company that is associated with the
given TeamViewer web API token.

The list can optionally be filtered.

## EXAMPLES

### Example 1

```powershell
Get-TeamViewerEventLog
```

Gets all audit log events of the current company that were created in the last
hour.

### Example 2

```powershell
Get-TeamViewerEventLog -Days 7
```

Gets all audit log events of the current company that were created in the last
seven days.

### Example 3

```powershell
Get-TeamViewerEventLog -StartDate "2021-10-01" -EventNames "UserCreated","UserDeleted"
```

Gets user creation & deletion audit log events of the current company that were
created since October 1st, 2021.

### Example 4

```powershell
Get-TeamViewerEventLog -Months 1 -EventTypes "LicenseManagement","Policy" -Limit 100
```

Gets up to 100 license management and policy related audit log events of the
current company that were created in the last month.

### Example 5

```powershell
Get-TeamViewerEventLog -StartDate "2021-10-01" -EndDate "2021-10-31" -AccountEmails "john.doe@example.com"
```

Gets all audit log events that were created by the given account within the
absolute date range of October 2021.

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

### -APIToken

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

- `ActiveConnectionsDisabled`
- `ActiveConnectionsEnabled`
- `AddRemoteWorkerDevice`
- `AISettingsEnduserStopSummaryDisabled`
- `AISettingsEnduserStopSummaryEnabled`
- `AISettingsIncomingConnectionsDisabled`
- `AISettingsIncomingConnectionsEnabled`
- `AISettingsIncomingConnectionsSelectionChanged`
- `AISettingsIntelligenceSuiteDisabled`
- `AISettingsIntelligenceSuiteEnabled`
- `AISettingsOutgoingConnectionsConfigurationModeChanged`
- `AISettingsOutgoingConnectionsDisabled`
- `AISettingsOutgoingConnectionsEnabled`
- `AISettingsOutgoingConnectionsSelectionChanged`
- `AISettingsSupporterStopSummaryDisabled`
- `AISettingsSupporterStopSummaryEnabled`
- `AISettingsUserGroupsDefaultDataCollectionModeChanged`
- `AISettingsUserGroupSettingAdded`
- `AISettingsUserGroupSettingChanged`
- `AISettingsUserGroupSettingRemoved`
- `AzureIntegrationEntraConnected`
- `AzureIntegrationEntraDisconnected`
- `AzureIntegrationLapsAccountCredentialsDisabled`
- `AzureIntegrationLapsAccountCredentialsEnabled`
- `AzureIntegrationLapsConnected`
- `AzureIntegrationLapsDisconnected`
- `AzureIntegrationLapsRotationDisabled`
- `AzureIntegrationLapsRotationEnabled`
- `ChangedDisabledRemoteInput`
- `ChangedShowBlackScreen`
- `CompanyAddressBookDisabled`
- `CompanyAddressBookEnabled`
- `CompanyAddressBookMembersHid`
- `CompanyAddressBookMembersUnhid`
- `CompanyDeviceGroupSetting`
- `CompanyRelationExternalAccessDeleted`
- `CompanyRelationExternalAccessRequestCreated`
- `CompanyRelationExternalAccessRequestUpdated`
- `CompanyRelationInvitationCreated`
- `CompanyRelationInvitationUpdated`
- `CompanyRelationRequestCreated`
- `CompanyRelationRequestDeleted`
- `CompanyRelationRequestUpdated`
- `CompanyRelationTerminated`
- `ConditionalAccessBlockMeetingStateChanged`
- `ConditionalAccessDirectoryGroupAdded`
- `ConditionalAccessDirectoryGroupDeleted`
- `ConditionalAccessDirectoryGroupMembersAdded`
- `ConditionalAccessDirectoryGroupMembersDeleted`
- `ConditionalAccessPreApprovedSessionRequestApproved`
- `ConditionalAccessPreApprovedSessionRequestDenied`
- `ConditionalAccessRuleAdded`
- `ConditionalAccessRuleDeleted`
- `ConditionalAccessRuleModified`
- `ConditionalAccessRuleVerificationStateChanged`
- `ConditionalAccessSessionApproval`
- `ConditionalAccessUseSessionCodeGroupIDStateChanged`
- `ConnectionTerminated`
- `ConnectionTerminationRequest`
- `CreateCustomHost`
- `DeleteCustomHost`
- `DeviceAddedToGroup`
- `DeviceAliasUpdated`
- `DeviceDescriptionUpdated`
- `DeviceGroupCreated`
- `DeviceGroupDeleted`
- `DeviceGroupManagerAdded`
- `DeviceGroupManagerRemoved`
- `DeviceGroupManagerUpdated`
- `DeviceGroupNameUpdated`
- `DeviceGroupPolicyUpdated`
- `DeviceManaged`
- `DeviceManagerAdded`
- `DeviceManagerRemoved`
- `DeviceManagerUpdated`
- `DevicePolicyUpdated`
- `DeviceRemovedFromGroup`
- `DeviceUnmanaged`
- `EditOwnProfile`
- `EditTFAUsage`
- `EditUserPermissions`
- `EditUserProperties`
- `EmailConfirmed`
- `EndedRecording`
- `EndedSession`
- `EventLogActivated`
- `EventLogDeactivated`
- `FailedChatTranscript`
- `GroupAdded`
- `GroupDeleted`
- `GroupShared`
- `GroupUpdated`
- `IncomingSession`
- `IntuneAutoDeployGroupActivated`
- `IntuneAutoDeployIntegrationConnected`
- `IntuneAutoDeployIntegrationDisconnected`
- `IntuneAutoDeployRolloutConfigurationSet`
- `IntuneDeviceSyncConfigurationChanged`
- `IntuneDeviceSyncGroupAdded`
- `IntuneDeviceSyncGroupRemoved`
- `IntuneDeviceSyncIntegrationConnected`
- `IntuneDeviceSyncIntegrationDisconnected`
- `IntuneDeviceSyncOwnerChanged`
- `JoinCompany`
- `JoinCompanyDenied`
- `JoinedSession`
- `LeftSession`
- `OrganizationalUnitCreated`
- `OrganizationalUnitDeleted`
- `OrganizationalUnitRootCreated`
- `OrganizationalUnitUpdated`
- `ParticipantJoinedSession`
- `ParticipantLeftSession`
- `PasswordChanged`
- `PasswordResetEmailRequesed`
- `PausedRecording`
- `PermissionInheritanceSetting`
- `PausedRecording`
- `PolicyAdded`
- `PolicyDeleted`
- `PolicyUpdated`
- `ReceivedDisabledLocalInput`
- `ReceivedFile`
- `ReceivedShowBlackScreen`
- `RemovedTFAEnforcementFromAccounts`
- `RemoveRemoteWorkerDevice`
- `ResumedRecording`
- `ScriptTokenAdded`
- `ScriptTokenDeleted`
- `ScriptTokenUpdated`
- `SentFile`
- `SingleSignOnDomainAccessLevelUpdated`
- `SingleSignOnDomainCreated`
- `SingleSignOnDomainDeleted`
- `SingleSignOnDomainUpdated`
- `SingleSignOnDomainUpdated`
- `SingleSignOnExclusionRemoved`
- `SingleSignOnInclusionAdded`
- `SingleSignOnInclusionRemoved`
- `SingleSignOnOwnerAdded`
- `SingleSignOnOwnerRemoved`
- `StartedChatTranscript`
- `StartedRecording`
- `StartedSession`
- `SwitchedSides`
- `TFAEnforcedOnAccounts`
- `UpdateCustomHost`
- `UserCreated`
- `UserDeleted`
- `UserGroupCreated`
- `UserGroupDeleted`
- `UserGroupMembersAdded`
- `UserGroupMembersRemoved`
- `UserGroupUpdated`
- `UserInvitationAccepted`
- `UserInvitationCreated`
- `UserInvitationDeleted`
- `UserInvitationResent`
- `UserInvitationUpdated`
- `UserRemovedFromCompany`
- `UserRoleAssigned`
- `UserRoleCreated`
- `UserRoleCreated`
- `UserRoleUnassigned`
- `UserRoleUpdated`

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

- `ActiveConnections`
- `AISettings`
- `AzureIntegration`
- `CompanyAddressBook`
- `CompanyAdministration`
- `CompanyRelation`
- `CompanySettings`
- `ConditionalAccess`
- `CustomModules`
- `DeviceGroupManagement`
- `DeviceManagement`
- `GroupManagement`
- `IntuneAutoDeploy`
- `IntuneDeviceSync`
- `LicenseManagement`
- `OrganizationalUnit`
- `Policy`
- `Session`
- `SingleSignOnManagement`
- `TFAEnforcement`
- `UserGroups`
- `UserInvitation`
- `UserProfile`
- `UserRole`

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
