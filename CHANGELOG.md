# Change Log

## 1.x.0 (2023-0x-xx)

### Added

- Added `Remove-TeamViewerUser` cmdlet to remove user from TeamViewer company. (Thanks @OtterKring)

### Changed

- Extended `Add-TeamViewerManager` to add user group as manager. (Thanks @OtterKring)

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
