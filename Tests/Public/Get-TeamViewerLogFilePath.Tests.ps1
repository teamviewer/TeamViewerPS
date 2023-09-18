BeforeAll {
    . "$PSScriptRoot/../../docs/Cmdlets/Public/Get-TeamViewerLogFilePath.ps1"
    @(Get-ChildItem -Path "$PSScriptRoot/../../docs/Cmdlets/Private/*.ps1") | `
        ForEach-Object { . $_.FullName }

}

Describe "Get-TeamViewerLogFilePath function" {
    It "Should find log files" {
        Mock Get-TSCSearchDirectory {
            @{
                "TestFolder1" = @("C:\Logs\TestFolder1")
                "TestFolder2" = @("C:\Logs\TestFolder2")
            }
        }

        Mock Test-Path { $true }

        Mock Get-ChildItem {
            [PSCustomObject]@{ Name = "file1.log"; FullName = "C:\Logs\TestFolder1\file1.log" },
            [PSCustomObject]@{ Name = "file2.log"; FullName = "C:\Logs\TestFolder2\file2.log" }
        }



        $result = Get-TeamViewerLogFilePath
        $result | Should -Contain "C:\Logs\TestFolder1\file1.log"
        $result | Should -Contain "C:\Logs\TestFolder2\file2.log"
    }

    It "Should handle no log files found" {
        Mock Get-TSCSearchDirectory {
            @{}
        }

        $result = Get-TeamViewerLogFilePath
        $result | Should -BeNullOrEmpty
    }


    Context "When TeamViewer is not installed" {
        BeforeAll {
            Mock Test-TeamViewerInstallation { return $false }
            Mock Write-Error { return }
        }

        It "Should write an error message" {
            Mock -CommandName "Write-Error" -MockWith { $null }
            Get-TeamViewerLogFilePath
            Assert-MockCalled -CommandName "Write-Error" -Exactly -Times 1
        }
}
}



