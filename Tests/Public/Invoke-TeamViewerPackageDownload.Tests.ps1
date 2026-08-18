BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Invoke-TeamViewerPackageDownload.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }

    $testTargetDirectory = Join-Path -Path $TestDrive -ChildPath 'downloads'
    New-Item -Path $testTargetDirectory -ItemType Directory | Out-Null
}

Describe 'Invoke-TeamViewerPackageDownload' {
    It 'Should download the selected package' {
        Mock Invoke-WebRequest { }

        $Result = Invoke-TeamViewerPackageDownload -PackageType Full -TargetDirectory $testTargetDirectory

        $Result | Should -Be (Join-Path $testTargetDirectory 'TeamViewer_Setup.exe')

        Should -Invoke Invoke-WebRequest -Times 1 -Scope It -ParameterFilter {
            $Uri -eq 'https://dl.teamviewer.com/download/TeamViewer_Setup.exe' -and
            $OutFile -eq (Join-Path $testTargetDirectory 'TeamViewer_Setup.exe') -and
            $UseBasicParsing -and
            $ErrorAction -eq 'Stop'
        }
    }

    It 'Should report download failures' {
        Mock Invoke-WebRequest { throw 'download failed' }
        Mock Write-Verbose { }

        $Result = Invoke-TeamViewerPackageDownload -PackageType Full -TargetDirectory $testTargetDirectory

        $Result | Should -BeNullOrEmpty

        Should -Invoke Write-Verbose -Times 1 -Scope It -ParameterFilter {
            $Message -like "Failed to download TeamViewer package to '$testTargetDirectory\TeamViewer_Setup.exe':*"
        }
    }

    It 'Should skip an existing package without Force' {
        New-Item -Path (Join-Path $testTargetDirectory 'TeamViewer_Setup.exe') -ItemType File | Out-Null

        Mock Invoke-WebRequest { }

        $Result = Invoke-TeamViewerPackageDownload -PackageType Full -TargetDirectory $testTargetDirectory

        $Result | Should -BeNullOrEmpty

        Should -Invoke Invoke-WebRequest -Times 0 -Scope It
    }
}
