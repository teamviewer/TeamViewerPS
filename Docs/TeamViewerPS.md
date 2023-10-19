# TeamViewerPS

# SHORT DESCRIPTION

Interact with the TeamViewer Web API as well as a locally installed TeamViewer client.

# LONG DESCRIPTION

TeamViewerPS allows to interact with the TeamViewer Web API as well as a locally installed TeamViewer client.

The module provides functions for the following categories:

## Device Assignment

Assign or unassign a device to a company

The following functions are available in this category:

[`Add-TeamViewerAssinment.md`](Help/Add-TeamViewerAssignment.md)

[`Remove-TeamViewerAssignment.md`](Help/Remove-TeamViewerAssignment.md)

## Customize Client

Manage customization of the locally installed TeamViewer Client.

[`Add-TeamViewerCustomization`](Help/Add-TeamViewerCustomization.md)

[`Remove-TeamViewerCustomization`](Help/Remove-TeamViewerCustomization.md)

## Computers & Contacts

Remotely manage the Computers & Contacts via the TeamViewer Web API.

The following functions are available in this category:

[`Get-TeamViewerContact`](Help/Get-TeamViewerContact.md)

[`Get-TeamViewerDevice`](Help/Get-TeamViewerDevice.md)

[`Get-TeamViewerGroup`](Help/Get-TeamViewerGroup.md)

[`New-TeamViewerContact`](Help/New-TeamViewerContact.md)

[`New-TeamViewerDevice`](Help/New-TeamViewerDevice.md)

[`New-TeamViewerGroup`](Help/New-TeamViewerGroup.md)

[`Remove-TeamViewerContact`](Help/Remove-TeamViewerContact.md)

[`Remove-TeamViewerDevice`](Help/Remove-TeamViewerDevice.md)

[`Remove-TeamViewerGroup`](Help/Remove-TeamViewerGroup.md)

[`Set-TeamViewerDevice`](Help/Set-TeamViewerDevice.md)

[`Set-TeamViewerGroup`](Help/Set-TeamViewerGroup.md)

[`Publish-TeamViewerGroup`](Help/Publish-TeamViewerGroup.md)

[`Unpublish-TeamViewerGroup`](Help/Unpublish-TeamViewerGroup.md)

## User Management

Remotely manage the user accounts of a TeamViewer company via the TeamViewer
Web API.

The following functions are available in this category:

[`Get-TeamViewerUser`](Help/Get-TeamViewerUser.md)

[`New-TeamViewerUser`](Help/New-TeamViewerUser.md)

[`Remove-TeamViewerUser`](Help/Remove-TeamViewerUser.md)

[`Set-TeamViewerUser`](Help/Set-TeamViewerUser.md)

## User Groups

Remotely manage the user groups of a TeamViewer company via the
TeamViewer Web API. Have user groups to organize company members.

The following functions are available in this category:

[`Get-TeamViewerUserGroup`](Help/Get-TeamViewerUserGroup.md)

[`New-TeamViewerUserGroup`](Help/New-TeamViewerUserGroup.md)

[`Set-TeamViewerUserGroup`](Help/Set-TeamViewerUserGroup.md)

[`Remove-TeamViewerUserGroup`](Help/Remove-TeamViewerUserGroup.md)

[`Get-TeamViewerUserGroupMember`](Help/Get-TeamViewerUserGroupMember.md)

[`Add-TeamViewerUserGroupMember`](Help/Add-TeamViewerUserGroupMember.md)

[`Remove-TeamViewerUserGroupMember`](Help/Remove-TeamViewerUserGroupMember.md)

## User Roles

Remotely manage the user roles of a TeamViewer company via the
TeamViewer Web API. Have user roles to assign roles to company members.

The following functions are available in this category:

[`Get-TeamViewerUserRole`](Help/Get-TeamViewerUserRole.md)

[`New-TeamViewerUserRole`](Help/New-TeamViewerUserRole.md)

[`Set-TeamViewerUserRole`](Help/Set-TeamViewerUserRole.md)

[`Remove-TeamViewerUserRole`](Help/Remove-TeamViewerUserRole.md)

[`Get-TeamViewerRoleAssignmentToAccount`](Help/Get-TeamviewerRoleAssignmentToAccount.md)

[`Get-TeamViewerRoleAssignmentToUserGroup`](Help/Get-TeamViewerRoleAssignmentToUserGroup.md)

[`Add-TeamViewerAccountToUserRole`](Help/Add-TeamViewerAccountToUserRole)

[`Add-TeamViewerUserGroupToUserRole`](Help/Add-TeamViewerAccountToUserRole)

[`Remove-TeamViewerAccountFromUserRole`](Help/Remove-TeamViewerAccountFromUserRole)

[`Remove-TeamViewerUserGroupFromUserRole`](Help/Remove-TeamViewerUserGroupFromUserRole)

## Managed Groups & Managed Devices

Remotely manage the managed groups and managed devices of an account via the TeamViewer Web API.

The following functions are available in this category:

[`Get-TeamViewerManagedDevice`](Help/Get-TeamViewerManagedDevice.md)

[`Get-TeamViewerManagedGroup`](Help/Get-TeamViewerManagedGroup.md)

[`Get-TeamViewerManagementId`](Help/Get-TeamViewerManagementId.md)

[`Get-TeamViewerManager`](Help/Get-TeamViewerManager.md)

[`New-TeamViewerManagedGroup`](Help/New-TeamViewerManagedGroup.md)

[`Set-TeamViewerManagedDevice`](Help/Set-TeamViewerManagedDevice.md)

[`Set-TeamViewerManagedGroup`](Help/Set-TeamViewerManagedGroup.md)

[`Set-TeamViewerManager`](Help/Set-TeamViewerManager.md)

[`Add-TeamViewerManagedDevice`](Help/Add-TeamViewerManagedDevice.md)

[`Add-TeamViewerManager`](Help/Add-TeamViewerManager.md)

[`Remove-TeamViewerManagedDevice`](Help/Remove-TeamViewerManagedDevice.md)

[`Remove-TeamViewerManagedDeviceManagement`](Help/Remove-TeamViewerManagedDeviceManagement.md)

[`Remove-TeamViewerManagedGroup`](Help/Remove-TeamViewerManagedGroup.md)

[`Remove-TeamViewerManager`](Help/Remove-TeamViewerManager.md)

[`Remove-TeamViewerPolicyFromManagedDevice`](Cmdlets/Pulic/Remove-TeamViewerpolicyFromManagedDevice.md)

## Policy Management

Remotely manage the policies of a TeamViewer company via the TeamViewer Web API.

The following functions are available in this category:

[`Get-TeamViewerPolicy`](Help/Get-TeamViewerPolicy.md)

[`New-TeamViewerPolicy`](Help/New-TeamViewerPolicy.md)

[`Remove-TeamViewerPolicy`](Help/Remove-TeamViewerPolicy.md)

[`Set-TeamViewerPolicy`](Help/Set-TeamViewerPolicy.md)

## Single Sign-On (SSO) Management

Remotely manage Single Sign-On configurations via the TeamViewer Web API.

The following functions are available in this category:

[`Get-TeamViewerSsoDomain`](Help/Get-TeamViewerSsoDomain.md)

[`Get-TeamViewerSsoExclusion`](Help/Get-TeamViewerSsoExclusion.md)

[`Add-TeamViewerSsoExclusion`](Help/Add-TeamViewerSsoExclusion.md)

[`Remove-TeamViewerSsoExclusion`](Help/Remove-TeamViewerSsoExclusion.md)

## Event Logs & Reporting

Retrieve event log entries or connection-reports of a TeamViewer company via the TeamViewer Web
API.

[`Get-TeamViewerConnectionReport`](Help/Get-TeamViewerConnectionReport.md)

[`Get-TeamViewerEventLog`](Help/Get-TeamViewerEventLog.md)

## Local Client Utilities

Utilities that help managing the local TeamViewer client.

The following functions are available in this category:

[`Export-TeamViewerSystemInformation`](Help/Export-TeamViewerSystemInformation.md)

[`Get-TeamViewerId`](Help/Get-TeamViewerId.md)

[`Get-TeamViewerService`](Help/Get-TeamViewerService.md)

[`Get-TeamViewerVersion`](Help/Get-TeamViewerVersion.md)

[`Get-TeamViewerInstallationDirectory`](Help/Get-TeamViewerInstallationDirectory.md)

[`Get-TeamViewerLogFilePath`](Help/Get-TeamViewerLogFilePath.md)

[`Invoke-TeamViewerPackageDownload`](Help/Invoke-TeamViewerPackageDownload.md)

[`Restart-TeamViewerService`](Help/Restart-TeamViewerService.md)

[`Start-TeamViewerService`](Help/Start-TeamViewerService.md)

[`Stop-TeamViewerService`](Help/Stop-TeamViewerService.md)

[`Test-TeamViewerConnectivity`](Help/Test-TeamViewerConnectivity.md)

[`Test-TeamViewerInstallation`](Help/Test-TeamViewerInstallation.md)

## Web API Utilities

Utilities that help working with the TeamViewer Web API related functions.

The following functions are available in this category:

[`Connect-TeamViewerApi`](Help/Connect-TeamViewerApi.md)

[`Disconnect-TeamViewerApi`](Help/Disconnect-TeamViewerApi.md)

[`Invoke-TeamViewerPing`](Help/Invoke-TeamViewerPing.md)

## Web API proxy

Functions that manage proxy when working with TeamViewer Web API related functions.

The following functions are available in this category:

[`Set-TeamViewerPSProxy`](Help/Set-TeamViewerPSProxy.md)

[`Remove-TeamViewerPSProxy`](Help/Remove-TeamViewerPSProxy.md)

# SEE ALSO

TeamViewerPS project page on Github: <https://github.com/TeamViewer/TeamViewerPS>

TeamViewer Web API Documentation: <https://webapi.teamviewer.com/api/v1/docs/index>

TeamViewer Homepage: <https://www.teamviewer.com/>
