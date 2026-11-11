<#
.SYNOPSIS
Checks whether required PowerShell modules are installed and optionally installs missing ones.

.DESCRIPTION
Validates that the required PowerShell modules for this project are available in the current PowerShell environment.
When the -Force switch is used, missing modules are installed for the current user.
By design, this script emits output only when an error occurs.

.EXAMPLE
./Test-PowerShellModules.ps1

Checks for the default required modules and throws an error if one is missing.

.EXAMPLE
./Test-PowerShellModules.ps1 -Modules @('Pester', 'PSScriptAnalyzer') -Force

Checks the specified modules and installs any that are missing.
#>

[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Low')]
param(
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string[]]$Modules = @('PSScriptAnalyzer', 'Pester'),

    [Parameter()]
    [switch]$Force
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# Normalize the requested module list: remove blanks, trim whitespace, and drop duplicates.
$Modules_Required = @(
    $Modules |
    Where-Object { -not [string]::IsNullOrWhiteSpace($_) } |
    ForEach-Object { $_.Trim() } |
    Select-Object -Unique
)

# Ensure the caller actually supplied at least one valid module name.
if (-not $Modules_Required) {
    throw 'No valid PowerShell module names were provided.'
}

# Discover which required modules are already installed in the current session environment.
$Modules_Available = Get-Module -ListAvailable -Name $Modules_Required -ErrorAction Stop | Select-Object -ExpandProperty Name -Unique
$Modules_Missing = $Modules_Required | Where-Object { $_ -notin $Modules_Available }

# If everything is present, the script exits quietly without any output.
if (-not $Modules_Missing) {
    return
}

# Without -Force, we fail fast so the caller can resolve the missing dependency explicitly.
if (-not $Force) {
    throw "Missing required PowerShell module(s): $($Modules_Missing -join ', ')."
}

# When forced, install each missing module individually and respect WhatIf/ShouldProcess semantics.
foreach ($module in $Modules_Missing) {
    if (-not $PSCmdlet.ShouldProcess($module, 'Installing missing PowerShell module...')) {
        continue
    }

    try {
        Install-Module -Name $module -Scope CurrentUser -Force -AllowClobber -SkipPublisherCheck -ErrorAction Stop
    }
    catch {
        # Surface a clear failure if installation cannot be completed.
        throw "Failed to install required PowerShell module '$module': $($_.Exception.Message)"
    }
}
