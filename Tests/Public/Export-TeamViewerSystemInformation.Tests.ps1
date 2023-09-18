BeforeAll {
    . "$PSScriptRoot/../../Docs/Cmdlets/Public/Export-TeamViewerSystemInformation.ps1"
    . "$PSScriptRoot/../../Docs/Cmdlets/Public/Test-TeamViewerInstallation.ps1"
    . "$PSScriptRoot/../../Docs/Cmdlets/Public/Get-TeamViewerInstallationDirectory.ps1"
    @(Get-ChildItem -Path "$PSScriptRoot/../../Docs/Cmdlets/Private/*.ps1") | `
        ForEach-Object { . $_.FullName }
        function Test-TeamViewerInstallation { return $true }
        function Get-OperatingSystem { return 'Windows' }
        function Get-Location { return 'C:\Temp' }
        function Get-TSCDirectoryFiles { return }
        function Get-InstalledSoftware { return }
        function Get-IpConfig { return }
        function Get-MSInfo32 { return }
        function Get-Hosts { return }
        function Get-NSLookUpData { return }
        function Get-RouteTable { return }
        function Get-RegistryPaths { return }
        function Get-ClientId { return '12345' }
        function Compress-Archive { return }
        function Test-Path { return $true }
        function Copy-Item {return}
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
            Assert-MockCalled -CommandName "Compress-Archive" -Exactly -Times 1
        }
    }

    Context "When TeamViewer is not installed" {
        BeforeAll {
            function Test-TeamViewerInstallation { return $false }
            function Write-Error { return }
        }

        It "Should write an error message" {
            Mock -CommandName "Write-Error" -MockWith { $null }
            Export-TeamViewerSystemInformation
            Assert-MockCalled -CommandName "Write-Error" -Exactly -Times 1
        }
    }
}


