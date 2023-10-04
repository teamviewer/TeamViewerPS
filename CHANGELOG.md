# Change Log

## 2.0.0 (2023-09-13)

### Added

- Added 'Set-TeamViewerApiURi' to use TeamViewer test API.
- Added user role commands to remotely manage user roles of a TeamViewer company.
- Added `Add-TeamViewerAssignment` and `Remove-TeamViewerAssignment` commands to assign and unassign a device from a TeamViewer company.
- Added `Add-TeamViewerCustomization` and `Remove-TeamViewerCustomization` commands to apply and remove customization.
- Added `Export-TeamViewerSystemInformation` to create zip file for support.
- Added `Set-TeamViewerPSProxy` and `Remove-TeamViewerPSProxy` to set proxy to access WebAPI.
- Added `Get-TeamViewerInstallationDirectory` to return installation directory.
- Added `Remove-TeamViewerPolicyFromManagedDevice` to remove policies from managed devices.
  
### Changed
  
- Extended `Invoke-TeamViewerPackageDownload` with MSI package type.
- Folder structure modified.
- `-RemovePolicy` switch removed from `Set-TeamViewerManagedDevice`.

### Fixed
  
- Fixed `Get-TeamViewerLinuxGlobalConfig` to handle null values.

## 1.5.2 (2023-09-18)

- Remove-TeamViewerPolicyFromManagedDevice has been added.
- ManagedGroupId parameter has been added to Set-TeamViewerManagedDevice.

## 1.5.1 (2023-07-18)

- Improved `User ID` parameter handling for `Add-TeamViewerUserGroupMember` and `Remove-TeamViewerUserGroupMember`

## 1.5.0 (2023-05-24)

### Added

- Added `Remove-TeamViewerUser` cmdlet to remove user from TeamViewer company. (Thanks @OtterKring)
- Added `Remove-TeamViewerManagedDeviceManagement` to unmanage a device.

### Changed

- Extended `Add-TeamViewerManager` to add user group as manager. (Thanks @OtterKring)
- Extended `TeamViewerManagedDevice` to have "LastSeenAt" available for managed devices

## 1.4.0 (2022-04-19)

### Fixed

- Fixed `-Group` parameter of `Remove-TeamViewerManagedDevice` to be mandatory.

### Added

- Added `Get-TeamViewerConnectionReport` cmdlet to fetch TeamViewer session/connection reports.

## 1.3.1 (2021-11)

### Fixed

- Fixed `Set-TeamViewerPolicy` to support changing policy settings.

### Changed

- Result of `Get-TeamViewerUser` now also includes license information.

## 1.3.0 (2021-11-29)

### Added

- Adds command `Get-TeamViewerEventLog` to fetch event log entries.
- Adds user group commands to remotely manage user groups of a TeamViewer company.

## 1.2.0 (2021-07-19)

### Added

- Adds command `Set-TeamViewerManagedDevice` to change properties of a managed device.
- Adds optional `Policy` property to `Get-TeamViewerManagedDevice` result entries.
- Adds `-Device` parameter to `Get-TeamViewerManagedGroup` command, allowing to
  fetch all managed groups that a particular device is part of.

## 1.1.0 (2021-04-15)

### Added

- Adds `Get-TeamViewerManagementId` command to fetch the Management ID of the current device.
- Adds support for 64-bit Windows TeamViewer installations.

### Changed

- Improved bulk support for `Add-TeamViewerSsoExclusion` and `Remove-TeamViewerSsoExclusion`.

## 1.0.0 (2021-01-15)

- Initial release of TeamViewerPS
