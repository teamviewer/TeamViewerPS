BeforeAll {
    . "$PSScriptRoot/../../docs/Cmdlets/Public/Export-TeamViewerSystemInformation.ps1"
    . "$PSScriptRoot/../../docs/Cmdlets/Public/Test-TeamViewerInstallation.ps1"
    . "$PSScriptRoot/../../docs/Cmdlets/Public/Get-TeamViewerInstallationDirectory.ps1"
    @(Get-ChildItem -Path "$PSScriptRoot/../../docs/Cmdlets/Private/*.ps1") | `
        ForEach-Object { . $_.FullName }
        Mock -CommandName  Test-TeamViewerInstallation { return $true }
        Mock -CommandName  Get-OperatingSystem { return 'Windows' }
        Mock -CommandName  Get-Location { return 'C:\Temp' }
        Mock -CommandName  Get-TSCDirectoryFile { return }
        Mock -CommandName  Get-InstalledSoftware { return }
        Mock -CommandName  Get-IpConfig { return }
        Mock -CommandName  Get-MSInfo32 { return }
        Mock -CommandName  Get-HostFile { return }
        Mock -CommandName  Get-NSLookUpData { return }
        Mock -CommandName  Get-RouteTable { return }
        Mock -CommandName  Get-RegistryPath { return }
        Mock -CommandName  Get-ClientId { return '12345' }
        Mock -CommandName  Compress-Archive { return }
        Mock -CommandName Test-Path  { return $true }
        Mock -CommandName  Copy-Item {return}
}

Describe "Export-TeamViewerSystemInformation" {
    Context "When TeamViewer is installed on Windows" {
        It "Should create a zip file with the correct name" {
            $TargetDirectory = 'C:\'
            $TempPath = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), [System.Guid]::NewGuid().ToString())
            $ZipFileName = 'TV_SC_12345_WINPS.zip'
            $ZipPath = Join-Path -Path "$TempPath\Data" -ChildPath $ZipFileName
            $CompressPath = Compress-Archive -Path $Temp\* -DestinationPath $ZipPath -Force
            Mock -CommandName "Join-Path" -MockWith { $ZipPath }
            Mock -CommandName "Copy-Item" -MockWith {$null}
            Mock -CommandName "Compress-Archive" -MockWith { $CompressPath }
            Export-TeamViewerSystemInformation -TargetDirectory $TargetDirectory
            Assert-MockCalled -CommandName "Join-Path" -Exactly -Times 1
            Assert-MockCalled -CommandName "Compress-Archive" -Times 1
        }
    }

    Context "When TeamViewer is not installed" {
        BeforeAll {
            Mock -CommandName Test-TeamViewerInstallation -MockWith { return $false }
            Mock -CommandName  Write-Error -MockWith { return }
        }

        It "Should write an error message" {
            Mock -CommandName "Write-Error" -MockWith { $null }
            Export-TeamViewerSystemInformation
            Assert-MockCalled -CommandName "Write-Error" -Exactly -Times 1
        }
    }
}


