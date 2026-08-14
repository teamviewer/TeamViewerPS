BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Invoke-TeamViewerPackageDownload.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }
}


Describe 'Invoke-TeamViewerPackageDownload' {
    BeforeEach {
        $script:downloadedUrl = $null
        $script:downloadedPath = $null
        $client = [PSCustomObject]@{}
        $client | Add-Member -MemberType ScriptMethod -Name DownloadFile -Value {
            param($url, $path)
            $script:downloadedUrl = $url
            $script:downloadedPath = $path
        }

        Mock New-Object { $client }
        Mock Test-Path { $false }
    }

    It 'Should download the selected package' {
        $result = Invoke-TeamViewerPackageDownload -PackageType Full -TargetDirectory $TestDrive

        $result | Should -Be (Join-Path $TestDrive 'TeamViewer_Setup.exe')
        $script:downloadedUrl | Should -Be 'https://dl.teamviewer.com/download/TeamViewer_Setup.exe'
        $script:downloadedPath | Should -Be (Join-Path $TestDrive 'TeamViewer_Setup.exe')
    }

    It 'Should use the requested major version endpoint' {
        Invoke-TeamViewerPackageDownload -PackageType Host -MajorVersion 15 -TargetDirectory $TestDrive

        $script:downloadedUrl | Should -Be 'https://dl.teamviewer.com/download/version_15x/TeamViewer_Host_Setup.exe'
    }

    It 'Should use the fixed MSI endpoint' {
        Invoke-TeamViewerPackageDownload -PackageType MSI64 -TargetDirectory $TestDrive

        $script:downloadedUrl | Should -Be 'https://dl.teamviewer.com/download/version_15x/TeamViewer_MSI64.zip'
    }

    It 'Should download an existing package when Force is specified' {
        Mock Test-Path { $true }

        Invoke-TeamViewerPackageDownload -PackageType Full -TargetDirectory $TestDrive -Force

        $script:downloadedPath | Should -Be (Join-Path $TestDrive 'TeamViewer_Setup.exe')
    }
}
