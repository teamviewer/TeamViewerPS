# Builds a release-ready TeamViewerPS package from the source cmdlet files.
# The script assembles the module, generates formatting and help assets,
# and copies the metadata files needed for packaging.
#requires -Modules BuildHelpers, Microsoft.PowerShell.PlatyPS

param(
    [Parameter()]
    [string]$Build_OutputPath = "$(Resolve-Path "$PSScriptRoot\..")\Build\TeamViewerPS",

    [Parameter()]
    [version]$Module_Version
)

# Resolve the repository layout so the build can source files from the correct directories.
$Repo_RootPath = Resolve-Path -Path "$PSScriptRoot\.."
$Repo_CmdletPath = Resolve-Path -Path "$PSScriptRoot\..\Cmdlets"

# Load helper functions used by the packaging flow.
. (Join-Path -Path $PSScriptRoot -ChildPath 'Get-FormatTypeName.ps1')
. (Join-Path -Path $PSScriptRoot -ChildPath 'New-FormatFile.ps1')

# Clean any prior build output before creating the new package.
if (Test-Path -Path $Build_OutputPath) {
    Write-Verbose 'Removing existing build output directory...'

    Remove-Item -Path $Build_OutputPath -Recurse -ErrorAction SilentlyContinue
}

Write-Verbose 'Creating build output directories...'
New-Item -Type Directory $Build_OutputPath | Out-Null

# Compile the module sources into a single .psm1 file for distribution.
$Build_ModulePath = (Join-Path -Path $Build_OutputPath -ChildPath 'TeamViewerPS.psm1')

Write-Verbose 'Compiling single-file TeamViewer module...'
$ModuleTypes = @(Get-ChildItem -Path (Join-Path -Path $Repo_CmdletPath -ChildPath 'TeamViewerPS.Types.ps1'))

$PrivateFunctions = @(Get-ChildItem -Path (Join-Path -Path $Repo_CmdletPath -ChildPath 'Private\*.ps1') -ErrorAction SilentlyContinue)
Write-Verbose "Found $($PrivateFunctions.Count) private function files."

$PublicFunctions = @(Get-ChildItem -Path (Join-Path -Path $Repo_CmdletPath -ChildPath 'Public\*.ps1') -ErrorAction SilentlyContinue)
Write-Verbose "Found $($PublicFunctions.Count) public function files."

@($ModuleTypes + $PrivateFunctions + $PublicFunctions) | Get-Content -Raw | ForEach-Object { $_; "`r`n" } | Set-Content -Path $Build_ModulePath -Encoding UTF8

# Generate format definitions based on the public output types exposed by the cmdlets.
Write-Verbose 'Generating format definitions...'
New-FormatFile -Path (Join-Path -Path $Repo_CmdletPath -ChildPath 'TeamViewerPS.format.ps1xml') -Destination (Join-Path -Path $Build_OutputPath -ChildPath 'TeamViewerPS.format.ps1xml')

# Build help content from the markdown source files for the packaged module.
Write-Verbose 'Building help from Markdown...'
$Help_Command = @(Measure-PlatyPSMarkdown -Path (Join-Path -Path $Repo_RootPath -ChildPath 'Docs\Help\*.md') |
    Where-Object -Property Filetype -Match 'CommandHelp' | ForEach-Object { Import-MarkdownCommandHelp -Path $_.FilePath })

$Help_OutputPath = Join-Path -Path $Build_OutputPath -ChildPath 'en-US'
$Help_Command | Export-MamlCommandHelp -OutputFolder $Help_OutputPath | Out-Null

Move-Item -LiteralPath (Join-Path -Path $Help_OutputPath -ChildPath 'TeamViewerPS\TeamViewerPS-help.xml') -Destination $Help_OutputPath
Remove-Item -Path (Join-Path -Path $Help_OutputPath -ChildPath 'TeamViewerPS') -Recurse

# Create the module manifest and update exported function metadata for the package.
Write-Verbose 'Creating module manifest...'
Copy-Item -Path (Join-Path -Path $Repo_CmdletPath -ChildPath 'TeamViewerPS.psd1') -Destination $Build_OutputPath

Update-Metadata -Path (Join-Path -Path $Build_OutputPath -ChildPath 'TeamViewerPS.psd1') -PropertyName 'FunctionsToExport' -Value $PublicFunctions.BaseName

if ($PSBoundParameters.ContainsKey('Module_Version')) {
    Update-Metadata -Path (Join-Path -Path $Build_OutputPath -ChildPath 'TeamViewerPS.psd1') -PropertyName 'ModuleVersion' -Value $Module_Version
}

# Copy the project documentation files into the packaged module folder.
Write-Verbose 'Copying additional files into the package...'
Copy-Item -Path (Join-Path -Path $Repo_RootPath -ChildPath 'CHANGELOG.md') -Destination "$Build_OutputPath"
Copy-Item -Path (Join-Path -Path $Repo_RootPath -ChildPath 'LICENSE.md') -Destination "$Build_OutputPath"
Copy-Item -Path (Join-Path -Path $Repo_RootPath -ChildPath 'README.md') -Destination "$Build_OutputPath"

Write-Output 'Package successfully built.'
