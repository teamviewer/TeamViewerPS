# Change Log

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
