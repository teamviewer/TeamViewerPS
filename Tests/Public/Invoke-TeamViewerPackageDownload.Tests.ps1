BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Invoke-TeamViewerPackageDownload.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }
}

Describe 'Invoke-TeamViewerPackageDownload' {
    It 'Should download the selected package' {
        Mock Test-Path { $false }
        Mock Invoke-WebRequest { }

        $result = Invoke-TeamViewerPackageDownload -PackageType Full -TargetDirectory 'testPath'

        $result | Should -Be 'testPath\TeamViewer_Setup.exe'
        Should -Invoke Invoke-WebRequest -Times 1 -Scope It -ParameterFilter {
            $Uri -eq 'https://dl.teamviewer.com/download/TeamViewer_Setup.exe' -and
            $OutFile -eq 'testPath\TeamViewer_Setup.exe' -and
            $UseBasicParsing -and
            $ErrorAction -eq 'Stop'
        }
    }

    It 'Should report download failures' {
        Mock Test-Path { $false }
        Mock Invoke-WebRequest { throw 'download failed' }
        Mock Write-Verbose { }

        $result = Invoke-TeamViewerPackageDownload -PackageType Full -TargetDirectory 'testPath'

        $result | Should -BeNullOrEmpty

        Should -Invoke Write-Verbose -Times 1 -Scope It -ParameterFilter {
            $Message -like "Failed to download TeamViewer package to 'testPath\TeamViewer_Setup.exe':*"
        }
    }

    It 'Should skip an existing package without Force' {
        Mock Test-Path { $true }
        Mock Invoke-WebRequest { }

        $result = Invoke-TeamViewerPackageDownload -PackageType Full -TargetDirectory 'testPath'

        $result | Should -BeNullOrEmpty

        Should -Invoke Invoke-WebRequest -Times 0 -Scope It
    }
}
