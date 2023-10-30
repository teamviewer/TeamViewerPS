BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Set-TeamViewerApiUri.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | `
        ForEach-Object { . $_.FullName }
}
