# TeamViewerPS

![CI](https://github.com/teamviewer/TeamViewerPS/workflows/CI/badge.svg)

TeamViewerPS allows to interact with the TeamViewer Web API as well as a locally installed TeamViewer client.

## Installation & Update

Downloads and installs TeamViewerPS from the Powershell Gallery using the following command:

```powershell
Install-Module TeamViewerPS
```

Execute the following command to update an existing installation of TeamViewerPS:

```powershell
Update-Module TeamViewerPS
```

## Usage

The following example code shows how to interact with the TeamViewer Web API functions by retrieving the list of users of a TeamViewer company:

```powershell
# Stores API token for Powershell session
# 1. Create a TeamViewer API access token in the Management Console: https://login.teamviewer.com
# 2. Enter the API token in the shown dialog
Connect-TeamViewerApi

# Retrieves users of a TeamViewer company
Get-TeamViewerUser
```

Another example below shows how to display the TeamViewer ID as well as the version of the locally installed TeamViewer client:

```powershell
# Returns the TeamViewer Id of the locally installed TeamViewer client
Get-TeamViewerId

# Returns the version of the locally installed TeamViewer client
Get-TeamViewerVersion
```

The documentation and help can be accessed using the following commands:

```powershell
# Starting point of the documentation
Get-Help TeamViewerPS

# List of available commands of this module
Get-Command -Module TeamViewerPS

# Help for specific module functions
Get-Help -Full Get-TeamViewerUser # ... or any other command
```

## Commands

The module provides functions for the following categories:

- _Organizational units_
- _Roles_
- _Users_
- _User groups_
- _Computers & Contacts_
- _Managed groups_
- _Policies_
- _Single Sign-On (SSO)_
- _TeamViewer client utilities_

Please see the [TeamViewerPS](Docs/TeamViewerPS.md) article for a more detailed list.

## Prerequisites

TeamViewerPS requires one of the following environments to run:

- PowerShell 5.1 (Windows) 
- PowerShell Core 6 (Windows, Linux)
- PowerShell 7 (Windows, Linux)

## License

Please see the file `LICENSE.md`.

## Links

- [TeamViewer company website](https://www.teamviewer.com/)
- [TeamViewerPS project on Github](https://github.com/TeamViewer/TeamViewerPS)
- [TeamViewer web API documentation](https://webapi.teamviewer.com/api/v1/docs/index)
- [TeamViewerPS on Powershell Gallery](https://www.powershellgallery.com/packages/TeamViewerPS)
