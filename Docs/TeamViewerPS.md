# TeamViewerPS

# SHORT DESCRIPTION

Interact with the TeamViewer web API as well as a locally installed TeamViewer client.

# LONG DESCRIPTION

TeamViewerPS is a PowerShell module for interacting with the TeamViewer Web API and managing a locally installed TeamViewer client.

## Device Assignment

Assign or unassign a device to a company / tenant.

[`Add-TeamViewerAssignment`](Help/Add-TeamViewerAssignment.md)

[`Remove-TeamViewerAssignment`](Help/Remove-TeamViewerAssignment.md)

## Customize Client

Manage the customization of the locally installed TeamViewer Client.

[`Add-TeamViewerCustomization`](Help/Add-TeamViewerCustomization.md)

[`Get-TeamViewerCustomModuleId`](Help/Get-TeamViewerCustomModuleId.md)

[`Remove-TeamViewerCustomization`](Help/Remove-TeamViewerCustomization.md)

## Company Management

Manage company / tenant details for the TeamViewer company associated with the API token.

[`Get-TeamViewerCompany`](Help/Get-TeamViewerCompany.md)

[`Get-TeamViewerLicense`](Help/Get-TeamViewerLicense.md)

[`Remove-TeamViewerCompany`](Help/Remove-TeamViewerCompany.md)

[`Set-TeamViewerCompany`](Help/Set-TeamViewerCompany.md)

## Computers & Contacts

Manage the devices & contacts via the TeamViewer web API.

[`Get-TeamViewerContact`](Help/Get-TeamViewerContact.md)

[`Get-TeamViewerDevice`](Help/Get-TeamViewerDevice.md)

[`Get-TeamViewerGroup`](Help/Get-TeamViewerGroup.md)

[`New-TeamViewerContact`](Help/New-TeamViewerContact.md)

[`New-TeamViewerDevice`](Help/New-TeamViewerDevice.md)

[`New-TeamViewerGroup`](Help/New-TeamViewerGroup.md)

[`Publish-TeamViewerGroup`](Help/Publish-TeamViewerGroup.md)

[`Remove-TeamViewerContact`](Help/Remove-TeamViewerContact.md)

[`Remove-TeamViewerDevice`](Help/Remove-TeamViewerDevice.md)

[`Remove-TeamViewerGroup`](Help/Remove-TeamViewerGroup.md)

[`Set-TeamViewerDevice`](Help/Set-TeamViewerDevice.md)

[`Set-TeamViewerGroup`](Help/Set-TeamViewerGroup.md)

[`Unpublish-TeamViewerGroup`](Help/Unpublish-TeamViewerGroup.md)

## User Management

Manage the user accounts of a TeamViewer company / tenant via the TeamViewer web API.

[`Get-TeamViewerAccount`](Help/Get-TeamViewerAccount.md)

[`Get-TeamViewerEffectivePermission`](Help/Get-TeamViewerEffectivePermission.md)

[`Get-TeamViewerRoleByUser`](Help/Get-TeamViewerRoleByUser.md)

[`Get-TeamViewerUser`](Help/Get-TeamViewerUser.md)

[`New-TeamViewerUser`](Help/New-TeamViewerUser.md)

[`Remove-TeamViewerUser`](Help/Remove-TeamViewerUser.md)

[`Remove-TeamViewerUserTFA`](Help/Remove-TeamViewerUserTFA.md)

[`Set-TeamViewerAccount`](Help/Set-TeamViewerAccount.md)

[`Set-TeamViewerUser`](Help/Set-TeamViewerUser.md)

## User Groups

Manage the user groups of a TeamViewer company / tenant via the TeamViewer web API.

[`Add-TeamViewerUserGroupMember`](Help/Add-TeamViewerUserGroupMember.md)

[`Get-TeamViewerRoleByUserGroup`](Help/Get-TeamViewerRoleByUserGroup.md)

[`Get-TeamViewerUserGroup`](Help/Get-TeamViewerUserGroup.md)

[`Get-TeamViewerUserGroupMember`](Help/Get-TeamViewerUserGroupMember.md)

[`New-TeamViewerUserGroup`](Help/New-TeamViewerUserGroup.md)

[`Remove-TeamViewerUserGroup`](Help/Remove-TeamViewerUserGroup.md)

[`Remove-TeamViewerUserGroupMember`](Help/Remove-TeamViewerUserGroupMember.md)

[`Set-TeamViewerUserGroup`](Help/Set-TeamViewerUserGroup.md)

## Roles

Manage the roles of a TeamViewer company / tenant via the TeamViewer web API.
Company / tenant users receive permissions by roles that are assigned to them or their groups.

[`Add-TeamViewerUserGroupToRole`](Help/Add-TeamViewerUserGroupToRole.md)

[`Add-TeamViewerUserToRole`](Help/Add-TeamViewerUserToRole.md)

[`Get-TeamViewerPredefinedRole`](Help/Get-TeamViewerPredefinedRole.md)

[`Get-TeamViewerRole`](Help/Get-TeamViewerRole.md)

[`Get-TeamViewerUserByRole`](Help/Get-TeamViewerUserByRole.md)

[`Get-TeamViewerUserGroupByRole`](Help/Get-TeamViewerUserGroupByRole.md)

[`New-TeamViewerRole`](Help/New-TeamViewerRole.md)

[`Remove-TeamViewerPredefinedRole`](Help/Remove-TeamViewerPredefinedRole.md)

[`Remove-TeamViewerRole`](Help/Remove-TeamViewerRole.md)

[`Remove-TeamViewerUserFromRole`](Help/Remove-TeamViewerUserFromRole.md)

[`Remove-TeamViewerUserGroupFromRole`](Help/Remove-TeamViewerUserGroupFromRole.md)

[`Set-TeamViewerPredefinedRole`](Help/Set-TeamViewerPredefinedRole.md)

[`Set-TeamViewerRole`](Help/Set-TeamViewerRole.md)

## Managed Groups & Managed Devices

Manage the managed groups and managed devices of an account / company / tenant via the TeamViewer web API.

[`Add-TeamViewerManagedDevice`](Help/Add-TeamViewerManagedDevice.md)

[`Add-TeamViewerManager`](Help/Add-TeamViewerManager.md)

[`Get-TeamViewerCompanyManagedDevice`](Help/Get-TeamViewerCompanyManagedDevice.md)

[`Get-TeamViewerDeviceCustomField`](Help/Get-TeamViewerDeviceCustomField.md)

[`Get-TeamViewerDeviceCustomFieldConfiguration`](Help/Get-TeamViewerDeviceCustomFieldConfiguration.md)

[`Get-TeamViewerManagedDevice`](Help/Get-TeamViewerManagedDevice.md)

[`Get-TeamViewerManagedGroup`](Help/Get-TeamViewerManagedGroup.md)

[`Get-TeamViewerManagementId`](Help/Get-TeamViewerManagementId.md)

[`Get-TeamViewerManager`](Help/Get-TeamViewerManager.md)

[`Move-TeamViewerManagedDevice`](Help/Move-TeamViewerManagedDevice.md)

[`New-TeamViewerDeviceCustomFieldConfiguration`](Help/New-TeamViewerDeviceCustomFieldConfiguration.md)

[`New-TeamViewerManagedGroup`](Help/New-TeamViewerManagedGroup.md)

[`Remove-TeamViewerDeviceCustomField`](Help/Remove-TeamViewerDeviceCustomField.md)

[`Remove-TeamViewerDeviceCustomFieldConfiguration`](Help/Remove-TeamViewerDeviceCustomFieldConfiguration.md)

[`Remove-TeamViewerManagedDevice`](Help/Remove-TeamViewerManagedDevice.md)

[`Remove-TeamViewerManagedDeviceManagement`](Help/Remove-TeamViewerManagedDeviceManagement.md)

[`Remove-TeamViewerManagedGroup`](Help/Remove-TeamViewerManagedGroup.md)

[`Remove-TeamViewerManager`](Help/Remove-TeamViewerManager.md)

[`Remove-TeamViewerPolicyFromManagedDevice`](Help/Remove-TeamViewerPolicyFromManagedDevice.md)

[`Remove-TeamViewerPolicyFromManagedGroup`](Help/Remove-TeamViewerPolicyFromManagedGroup.md)

[`Set-TeamViewerDeviceCustomField`](Help/Set-TeamViewerDeviceCustomField.md)

[`Set-TeamViewerDeviceCustomFieldConfiguration`](Help/Set-TeamViewerDeviceCustomFieldConfiguration.md)

[`Set-TeamViewerManagedDevice`](Help/Set-TeamViewerManagedDevice.md)

[`Set-TeamViewerManagedGroup`](Help/Set-TeamViewerManagedGroup.md)

[`Set-TeamViewerManager`](Help/Set-TeamViewerManager.md)

## Policy Management

Manage the policies of a TeamViewer company / tenant via the TeamViewer web API.

[`Get-TeamViewerPolicy`](Help/Get-TeamViewerPolicy.md)

[`New-TeamViewerPolicy`](Help/New-TeamViewerPolicy.md)

[`Remove-TeamViewerPolicy`](Help/Remove-TeamViewerPolicy.md)

[`Set-TeamViewerPolicy`](Help/Set-TeamViewerPolicy.md)

## Single Sign-On (SSO) Management

Manage Single Sign-On (SSO) configurations via the TeamViewer web API.

[`Add-TeamViewerSsoExclusion`](Help/Add-TeamViewerSsoExclusion.md)

[`Add-TeamViewerSsoInclusion`](Help/Add-TeamViewerSsoInclusion.md)

[`Get-TeamViewerSsoDomain`](Help/Get-TeamViewerSsoDomain.md)

[`Get-TeamViewerSsoExclusion`](Help/Get-TeamViewerSsoExclusion.md)

[`Get-TeamViewerSsoInclusion`](Help/Get-TeamViewerSsoInclusion.md)

[`Remove-TeamViewerSsoExclusion`](Help/Remove-TeamViewerSsoExclusion.md)

[`Remove-TeamViewerSsoInclusion`](Help/Remove-TeamViewerSsoInclusion.md)

## Event Logs & Reporting

Retrieve event log entries or connection-reports of a TeamViewer company / tenant via the TeamViewer web API.

[`Get-TeamViewerConnectionReport`](Help/Get-TeamViewerConnectionReport.md)

[`Get-TeamViewerEventLog`](Help/Get-TeamViewerEventLog.md)

## Local Client Utilities

Utilities that help managing the local TeamViewer client.

[`Get-TeamViewerId`](Help/Get-TeamViewerId.md)

[`Get-TeamViewerInstallationDirectory`](Help/Get-TeamViewerInstallationDirectory.md)

[`Get-TeamViewerInstallationPackage`](Help/Get-TeamViewerInstallationPackage.md)

[`Get-TeamViewerInstallationType`](Help/Get-TeamViewerInstallationType.md)

[`Get-TeamViewerLogFilePath`](Help/Get-TeamViewerLogFilePath.md)

[`Get-TeamViewerService`](Help/Get-TeamViewerService.md)

[`Get-TeamViewerVersion`](Help/Get-TeamViewerVersion.md)

[`Invoke-TeamViewerPackageDownload`](Help/Invoke-TeamViewerPackageDownload.md)

[`Restart-TeamViewerService`](Help/Restart-TeamViewerService.md)

[`Start-TeamViewerService`](Help/Start-TeamViewerService.md)

[`Stop-TeamViewerService`](Help/Stop-TeamViewerService.md)

[`Test-TeamViewerConnectivity`](Help/Test-TeamViewerConnectivity.md)

[`Test-TeamViewerInstallation`](Help/Test-TeamViewerInstallation.md)

## Web API Utilities

Utilities that help working with the TeamViewer web API related functions.

[`Connect-TeamViewerApi`](Help/Connect-TeamViewerApi.md)

[`Disconnect-TeamViewerApi`](Help/Disconnect-TeamViewerApi.md)

[`Invoke-TeamViewerPing`](Help/Invoke-TeamViewerPing.md)

[`Remove-TeamViewerPSProxy`](Help/Remove-TeamViewerPSProxy.md)

[`Set-TeamViewerPSProxy`](Help/Set-TeamViewerPSProxy.md)

# SEE ALSO

TeamViewerPS on GitHub <https://github.com/teamviewer/TeamViewerPS>

TeamViewerPS on PowerShell Gallery <https://www.powershellgallery.com/packages/TeamViewerPS>

TeamViewer web API docs <https://webapi.teamviewer.com/api/v1/docs/index>

TeamViewer company website <https://www.teamviewer.com/>
