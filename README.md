# TeamViewerPS

TeamViewerPS allows to interact with the TeamViewer Web API as well as a locally
installed TeamViewer client.

## Installation

Install TeamViewerPS from the Powershell Gallery using the following command:

```powershell
Install-Module TeamViewerPS
```

Execute the following command to update an existing installation of
TeamViewerPS:

```powershell
Update-Module TeamViewerPS
```

## Usage

The following example code shows how to interact with the TeamViewer Web API
functions by retrieving the list of users of a TeamViewer company:

```powershell
Install-Module TeamViewerPS
Connect-TeamViewerApi
# Enter the TeamViewer API access token that has been created via the
# Management Console: https://login.teamviewer.com

Get-TeamViewerUser
```

Another example below shows how to display the TeamViewer ID as well as the
version of the locally installed TeamViewer client:

```powershell
Install-Module TeamViewerPS
Get-TeamViewerId
Get-TeamViewerVersion
```

The documentation and help can be accessed using the following commands:

```powershell
# Starting point of the documentation
Get-Help about_TeamViewerPS

# List of available commands of this module
Get-Command -Module TeamViewerPS

# Help for specific module functions
Get-Help -Full Get-TeamViewerUser # ... or any other command
```

## Commands

The module provides functions for the following categories:

- _Computers & Contacts list_
- _User management_
- _Managed groups_
- _Policy management_
- _Local TeamViewer utilities_

Please see the [about_TeamViewerPS](docs/about_TeamViewerPS.md) article for a
more detailed list.

## License

Please see the file `LICENSE`.

## Links

- [TeamViewerPS project page on Github](https://github.com/TeamViewer/TeamViewerPS)
- [TeamViewer Web API Documentation](https://webapi.teamviewer.com/api/v1/docs/index)
- [TeamViewer Homepage](https://www.teamviewer.com/)
