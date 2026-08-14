BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Invoke-TeamViewerPackageDownload.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }
}

Describe 'Invoke-TeamViewerPackageDownload' {
    It 'Should reject unsupported TeamViewer versions' {
        { Invoke-TeamViewerPackageDownload -PackageType Full -MajorVersion 13 -TargetDirectory (Get-Location).Path } | Should -Throw
    }

    It 'Should reject major versions for MSI packages' {
        { Invoke-TeamViewerPackageDownload -PackageType MSI64 -MajorVersion 15 -TargetDirectory (Get-Location).Path } | Should -Throw
    }

    It 'Should reject a missing target directory' {
        { Invoke-TeamViewerPackageDownload -PackageType Full -TargetDirectory (Join-Path (Get-Location).Path 'missing') } | Should -Throw
    }
}
