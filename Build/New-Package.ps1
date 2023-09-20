#requires -Modules platyPS, BuildHelpers

param(
    [Parameter()]
    [string]
    $BuildOutputPath = "$(Resolve-Path "$PSScriptRoot/..")/Build/Output"
)

$repoPath = Resolve-Path "$PSScriptRoot/.."

if (Test-Path $BuildOutputPath) {
    Write-Verbose 'Removing existing build output directory'
    Remove-Item $BuildOutputPath -Recurse -ErrorAction SilentlyContinue
}
Write-Verbose 'Creating build output directories.'
New-Item -Type Directory $BuildOutputPath | Out-Null


# Compile all functions into a single psm file
$targetFile = "$BuildOutputPath/TeamViewerPS.psm1"
Write-Verbose 'Compiling single-file TeamViewer module.'
$ModuleTypes = @(Get-ChildItem -Path "$repoPath/Docs/TeamViewerPS.Types.ps1")
$PrivateFunctions = @(Get-ChildItem `
        -Path "$repoPath/Docs/Cmdlets/Private/*.ps1" `
        -ErrorAction SilentlyContinue)
Write-Verbose "Found $($PrivateFunctions.Count) private function files."
$PublicFunctions = @(Get-ChildItem `
        -Path "$repoPath/Docs/Cmdlets/Public/*.ps1" `
        -ErrorAction SilentlyContinue)
Write-Verbose "Found $($PublicFunctions.Count) public function files."
@($ModuleTypes + $PrivateFunctions + $PublicFunctions) | `
    Get-Content -Raw | `
    ForEach-Object { $_; "`r`n" } | `
    Set-Content -Path $targetFile -Encoding UTF8

# Create help from markdown
Write-Verbose 'Building help from Markdown'
New-ExternalHelp `
    -Path "$repoPath/Docs" `
    -OutputPath "$BuildOutputPath/en-US" | `
    Out-Null
New-ExternalHelp `
    -Path "$repoPath/Docs/Cmdlets_help" `
    -OutputPath "$BuildOutputPath/en-US" | `
    Out-Null

# Create module manifest
Write-Verbose 'Creating module manifest'
Copy-Item `
    -Path "$repoPath/Docs/TeamViewerPS.psd1" `
    -Destination "$BuildOutputPath/"
Copy-Item `
    -Path "$repoPath/Docs/*.format.ps1xml" `
    -Destination "$BuildOutputPath/"
Update-Metadata `
    -Path "$BuildOutputPath/TeamViewerPS.psd1" `
    -PropertyName 'FunctionsToExport' `
    -Value $PublicFunctions.BaseName

# Copy additional package files
Write-Verbose 'Copying additional files into the package'
Copy-Item `
    -Path `
    "$repoPath/LICENSE.md", `
    "$repoPath/CHANGELOG.md", `
    "$repoPath/README.md"`
    -Destination "$BuildOutputPath/"

Write-Verbose 'Listing package files:'
Push-Location $BuildOutputPath
Get-ChildItem -Recurse "$BuildOutputPath/" | `
    Sort-Object -Property FullName | `
    Resolve-Path -Relative
Pop-Location
