# TeamViewerPS

![CI](https://github.com/teamviewer/TeamViewerPS/workflows/CI/badge.svg)

TeamViewerPS is a PowerShell module for interacting with the TeamViewer Web API and managing a locally installed TeamViewer client.

## Installation

Install the latest released version from the PowerShell Gallery:

```powershell
Install-Module -Name TeamViewerPS
```

If the module is already installed, update it with:

```powershell
Update-Module -Name TeamViewerPS
```

If you need to load the module explicitly after install:

```powershell
Import-Module TeamViewerPS
```

## Prerequisites

TeamViewerPS supports:

- Windows PowerShell 5.1 on Windows
- PowerShell Core 6+ on Windows
- PowerShell 7+ on Windows

## Quick Start

### Connect to the TeamViewer Web API

Create a TeamViewer API access token in the [TeamViewer user profile](https://web.teamviewer.com/settings/profile/apps), then connect:

```powershell
$apiToken = Read-Host -Prompt 'TeamViewer API token' -AsSecureString
Connect-TeamViewerApi -ApiToken $apiToken
```

Once connected, you can call Web API commands without specifying the token again:

```powershell
Get-TeamViewerUser
Get-TeamViewerGroup
Get-TeamViewerPolicy
```

### Disconnect from the Web API

```powershell
Disconnect-TeamViewerApi
```

## Usage Examples

### Retrieve company users

```powershell
Get-TeamViewerUser
```

### Get local TeamViewer client information

```powershell
Get-TeamViewerId
Get-TeamViewerVersion
Get-TeamViewerInstallationDirectory
Get-TeamViewerLogFilePath
```

### Test connectivity

```powershell
Test-TeamViewerConnectivity
```

## Configuration

### Use a proxy

If your environment requires a proxy for web API requests, configure it with:

```powershell
Set-TeamViewerPSProxy -ProxyUri 'http://proxy.example.com:3128'
```

To remove the configured proxy:

```powershell
Remove-TeamViewerPSProxy
```

## Discover commands and help

List available TeamViewerPS commands:

```powershell
Get-Command -Module TeamViewerPS
```

Read module help and specific command help:

```powershell
Get-Help TeamViewerPS
Get-Help -Full Connect-TeamViewerApi
Get-Help -Full Get-TeamViewerUser
```

## Documentation

For a full list of supported commands and detailed reference documentation, see:

- [`Docs/TeamViewerPS.md`](Docs/TeamViewerPS.md)
- [`Docs/Help`](Docs/Help)

## Contributing

We welcome contributions to improve and expand TeamViewerPS.

- Fork the repository and create a feature branch.
- Open an issue first if you are unsure about the change.
- Add tests for new function / behavior when applicable.
- Keep help / documentation up-to-date.
- Keep code style consistent with existing PowerShell module conventions.

To run the repository tests locally:

```powershell
Invoke-Pester -Path .
```

If you want to lint the module before submitting a pull request:

```powershell
Invoke-ScriptAnalyzer -Path . -Recurse -Settings .\Linters\PSScriptAnalyzer.psd1
```

Please submit pull requests against the `main` branch.

## License

Please see the file `LICENSE.md`.

## Links

- [TeamViewerPS on GitHub](https://github.com/teamviewer/TeamViewerPS)
- [TeamViewerPS on PowerShell Gallery](https://www.powershellgallery.com/packages/TeamViewerPS)
- [TeamViewer Web API docs](https://webapi.teamviewer.com/api/v1/docs/index)
- [TeamViewer company website](https://www.teamviewer.com/)
