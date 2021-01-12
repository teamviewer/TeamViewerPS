# TeamViewerPS

## about_TeamViewerPS

# SHORT DESCRIPTION

TeamViewerPS allows to interact with the TeamViewer Web API as well as a locally
installed TeamViewer client.

# LONG DESCRIPTION

TeamViewerPS allows to interact with the TeamViewer Web API as well as a locally
installed TeamViewer client.

The module provides functions for the following categories:

## Computers & Contacts list

Remotely manage the Computers & Contacts list via the TeamViewer Web API.

The following functions are available in this category:

- `Get-TeamViewerContact`
- `Get-TeamViewerDevice`
- `Get-TeamViewerGroup`
- `New-TeamViewerContact`
- `New-TeamViewerDevice`
- `New-TeamViewerGroup`
- `Remove-TeamViewerContact`
- `Remove-TeamViewerDevice`
- `Remove-TeamViewerGroup`
- `Set-TeamViewerDevice`
- `Set-TeamViewerGroup`
- `Publish-TeamViewerGroup`
- `Unpublish-TeamViewerGroup`

## User management

Remotely manage the user accounts of a TeamViewer company via the TeamViewer
Web API.

The following functions are available in this category:

- `Get-TeamViewerUser`
- `New-TeamViewerUser`
- `Remove-TeamViewerUser`
- `Set-TeamViewerUser`

## Managed groups

Remotely manage the managed groups and managed devices of an account via the
TeamViewer Web API.

The following functions are available in this category:

- `Get-TeamViewerManagedDevice`
- `Get-TeamViewerManagedGroup`
- `Get-TeamViewerManager`
- `New-TeamViewerManagedGroup`
- `Set-TeamViewerManagedGroup`
- `Set-TeamViewerManager`
- `Add-TeamViewerManagedDevice`
- `Add-TeamViewerManager`
- `Remove-TeamViewerManagedDevice`
- `Remove-TeamViewerManagedGroup`
- `Remove-TeamViewerManager`

## Policy management

Remotely manage the policies of a TeamViewer company via the TeamViewer Web API.

The following functions are available in this category:

- `Get-TeamViewerPolicy`
- `New-TeamViewerPolicy`
- `Remove-TeamViewerPolicy`
- `Set-TeamViewerPolicy`

## Local TeamViewer utilities

Utilities that help managing the local TeamViewer installation.

The following functions are available in this category:

- `Get-TeamViewerId`
- `Get-TeamViewerService`
- `Get-TeamViewerVersion`
- `Invoke-TeamViewerPackageDownload`
- `Restart-TeamViewerService`
- `Start-TeamViewerService`
- `Stop-TeamViewerService`
- `Test-TeamViewerConnectivity`
- `Test-TeamViewerInstallation`

# SEE ALSO

TeamViewerPS project page on Github: <https://github.com/TeamViewer/TeamViewerPS>

TeamViewer Web API Documentation: <https://webapi.teamviewer.com/api/v1/docs/index>

TeamViewer Homepage: <https://www.teamviewer.com/>
