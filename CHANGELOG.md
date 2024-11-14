# Change Log

## 2.0.1 (2024-11-14)

### Added
- Add-TeamViewerSsoInclusion command to add SSO Inclusion list items.

## 2.0.0 (2023-11-22)

### Added

- Adds commands to manage the roles of a TeamViewer company.
- Adds `Set-TeamViewerApiURi` to use TeamViewer test API.
- Adds `Add-TeamViewerAssignment` and `Remove-TeamViewerAssignment` commands to assign and unassign a device from a TeamViewer company.
- Adds `Add-TeamViewerCustomization` and `Remove-TeamViewerCustomization` commands to apply and remove customization.
- Adds `Export-TeamViewerSystemInformation` to create zip file for support.
- Adds `Set-TeamViewerPSProxy` and `Remove-TeamViewerPSProxy` to set proxy to access WebAPI.
- Adds `Get-TeamViewerInstallationDirectory` to return installation directory.
- Adds `Get-TeamViewerCustomModuleId` to return custom module ID.
- Adds `Get-TeamViewerLogFilePath` to return log file paths for different logs present.
- Adds `Remove-TeamViewerPolicyFromManagedDevice` to remove policies from managed devices.

### Changed

- Extends `Invoke-TeamViewerPackageDownload` with MSI package type.
- Removes `-RemovePolicy` switch from `Set-TeamViewerManagedDevice`.
- Modifies general module folder structure.

### Fixed

- Fixes `Get-TeamViewerLinuxGlobalConfig` to handle null values.

## 1.5.2 (2023-09-18)

### Added

- Adds `Remove-TeamViewerPolicyFromManagedDevice` to remove a policy from a managed device.

### Changed

- Adds `ManagedGroupId` parameter to `Set-TeamViewerManagedDevice`.

## 1.5.1 (2023-07-18)

- Improves `User ID` parameter handling for `Add-TeamViewerUserGroupMember` and `Remove-TeamViewerUserGroupMember`.

## 1.5.0 (2023-05-24)

### Added

- Adds `Remove-TeamViewerUser` cmdlet to remove user from TeamViewer company. (Thanks @OtterKring)
- Adds `Remove-TeamViewerManagedDeviceManagement` to un-manage a device.

### Changed

- Extends `Add-TeamViewerManager` to add user group as manager. (Thanks @OtterKring)
- Adds `LastSeenAt` to `TeamViewerManagedDevice` for managed devices.

## 1.4.0 (2022-04-19)

### Added

- Adds `Get-TeamViewerConnectionReport` cmdlet to fetch TeamViewer session / connection reports.

### Fixed

- Fixes `-Group` parameter of `Remove-TeamViewerManagedDevice` to be mandatory.

## 1.3.1 (2021-11)

### Changed

- `Get-TeamViewerUser` includes license information.

### Fixed

- Fixes `Set-TeamViewerPolicy` to support changing policy settings.

## 1.3.0 (2021-11-29)

### Added

- Adds `Get-TeamViewerEventLog` to fetch event log entries.
- Adds user group commands to remotely manage user groups of a TeamViewer company.

## 1.2.0 (2021-07-19)

### Added

- Adds command `Set-TeamViewerManagedDevice` to change properties of a managed device.
- Adds optional `Policy` property to `Get-TeamViewerManagedDevice` result entries.
- Adds `-Device` parameter to `Get-TeamViewerManagedGroup` command, allowing to fetch all managed groups that a particular device is part of.

## 1.1.0 (2021-04-15)

### Added

- Adds `Get-TeamViewerManagementId` command to fetch the Management ID of the current device.
- Adds support for 64-bit Windows TeamViewer installations.

### Changed

- Improves bulk support for `Add-TeamViewerSsoExclusion` and `Remove-TeamViewerSsoExclusion`.

## 1.0.0 (2021-01-15)

- Initial release of TeamViewerPS
