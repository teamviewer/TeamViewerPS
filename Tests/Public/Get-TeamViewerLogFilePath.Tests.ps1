BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Get-TeamViewerLogFilePath.ps1"
    . "$PSScriptRoot\..\..\Cmdlets\Public\Test-TeamViewerInstallation.ps1"
    . "$PSScriptRoot\..\..\Cmdlets\Public\Get-TeamViewerInstallationDirectory.ps1"
    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | `
        ForEach-Object { . $_.FullName }

        Mock Get-TSCSearchDirectory {
            @{
                'TestFolder1' = @('C:\Logs\TestFolder1')
                'TestFolder2' = @('C:\Logs\TestFolder2')
            }
        }
        Mock Test-Path { $true }
        Mock Get-ChildItem {
            [PSCustomObject]@{ Name = 'file1.log'; FullName = 'C:\Logs\TestFolder1\file1.log' },
            [PSCustomObject]@{ Name = 'file2.log'; FullName = 'C:\Logs\TestFolder2\file2.log' }
        }

}

Describe 'Get-TeamViewerLogFilePath function' {
    Context 'When TeamViewer is not installed' {
        BeforeAll {
            Mock Test-TeamViewerInstallation { return $false }
            Mock Write-Error { return }
        }

        It 'Should write an error message' {
            Mock -CommandName 'Write-Error' -MockWith { $null }
            Get-TeamViewerLogFilePath
            Assert-MockCalled -CommandName 'Write-Error' -Exactly -Times 1
        }
    }
}



