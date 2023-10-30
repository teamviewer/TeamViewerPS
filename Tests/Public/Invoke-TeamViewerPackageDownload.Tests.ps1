BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Invoke-TeamViewerPakcageDownload.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | `
        ForEach-Object { . $_.FullName }
}
