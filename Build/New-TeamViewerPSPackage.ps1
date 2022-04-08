#requires -Modules platyPS, BuildHelpers

param(
    [Parameter()]
    [string]
    $BuildOutputPath = "$(Resolve-Path "$PSScriptRoot/..")/BuildOutput"
)

$repoPath = Resolve-Path "$PSScriptRoot/.."

if (Test-Path $BuildOutputPath) {
    Write-Verbose 'Removing existing build output directory'
    Remove-Item $BuildOutputPath -Recurse -ErrorAction SilentlyContinue
}
Write-Verbose 'Creating build output directories.'
New-Item -Type Directory $BuildOutputPath | Out-Null
New-Item -Type Directory "$BuildOutputPath/TeamViewerPS" | Out-Null

# Compile all functions into a single psm file
$targetFile = "$BuildOutputPath/TeamViewerPS/TeamViewerPS.psm1"
Write-Verbose "Compiling single-file TeamViewer module."
$ModuleTypes = @(Get-ChildItem -Path "$repoPath/TeamViewerPS/TeamViewerPS.Types.ps1")
$PrivateFunctions = @(Get-ChildItem `
        -Path "$repoPath/TeamViewerPS/Private/*.ps1" `
        -ErrorAction SilentlyContinue)
Write-Verbose "Found $($PrivateFunctions.Count) private function files."
$PublicFunctions = @(Get-ChildItem `
        -Path "$repoPath/TeamViewerPS/Public/*.ps1" `
        -ErrorAction SilentlyContinue)
Write-Verbose "Found $($PublicFunctions.Count) public function files."
@($ModuleTypes + $PrivateFunctions + $PublicFunctions) | `
    Get-Content -Raw | `
    ForEach-Object { $_; "`r`n" } | `
    Set-Content -Path $targetFile -Encoding utf8NoBOM

# Create help from markdown
Write-Verbose "Building help from Markdown"
New-ExternalHelp `
    -Path "$repoPath/docs" `
    -OutputPath "$BuildOutputPath/TeamViewerPS/en-US" | `
    Out-Null
New-ExternalHelp `
    -Path "$repoPath/docs/commands" `
    -OutputPath "$BuildOutputPath/TeamViewerPS/en-US" | `
    Out-Null

# Create module manifest
Write-Verbose "Creating module manifest"
Copy-Item `
    -Path "$repoPath/TeamViewerPS/TeamViewerPS.psd1" `
    -Destination "$BuildOutputPath/TeamViewerPS/"
Copy-Item `
    -Path "$repoPath/TeamViewerPS/*.format.ps1xml" `
    -Destination "$BuildOutputPath/TeamViewerPS/"
Update-Metadata `
    -Path "$BuildOutputPath/TeamViewerPS/TeamViewerPS.psd1" `
    -PropertyName 'FunctionsToExport' `
    -Value $PublicFunctions.BaseName

# Copy additional package files
Write-Verbose "Copying additional files into the package"
Copy-Item `
    -Path `
    "$repoPath/LICENSE", `
    "$repoPath/CHANGELOG.md", `
    "$repoPath/README.md"`
    -Destination "$BuildOutputPath/TeamViewerPS/"

Write-Verbose "Listing package files:"
Push-Location $BuildOutputPath
Get-ChildItem -Recurse "$BuildOutputPath/TeamViewerPS" | `
    Sort-Object -Property FullName | `
    Resolve-Path -Relative
Pop-Location
