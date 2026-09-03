BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Get-TeamViewerLogFilePath.ps1"
    . "$PSScriptRoot\..\..\Cmdlets\Public\Test-TeamViewerInstallation.ps1"
    . "$PSScriptRoot\..\..\Cmdlets\Public\Get-TeamViewerInstallationDirectory.ps1"
    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }

}

Describe 'Get-TeamViewerLogFilePath function' {
    Context 'When TeamViewer is installed' {
        BeforeAll {
            $script:OriginalAppData = $env:APPDATA
            $script:OriginalLocalAppData = $env:LOCALAPPDATA
            $env:APPDATA = 'C:\Users\Test\AppData\Roaming'
            $env:LOCALAPPDATA = 'C:\Users\Test\AppData\Local'

            $script:SearchPaths = @(
                'C:\TV',
                'C:\Users\Test\AppData\Local\TeamViewer\Logs',
                'C:\Users\Test\AppData\Roaming\TeamViewer'
            )

            Mock Test-TeamViewerInstallation { $true }
            Mock Get-TeamViewerInstallationDirectory { 'C:\TV' }
            Mock Test-Path -ParameterFilter { $Path -eq 'C:\TV' } { $true }
            Mock Test-Path -ParameterFilter { $Path -eq 'C:\Users\Test\AppData\Local\TeamViewer\Logs' } { $true }
            Mock Test-Path -ParameterFilter { $Path -eq 'C:\Users\Test\AppData\Roaming\TeamViewer' } { $true }
            Mock Get-ChildItem -ParameterFilter { $Path -eq 'C:\TV' } {
                @(
                    [PSCustomObject]@{ Name = 'file1.log'; FullName = 'C:\TV\file1.log' }
                    [PSCustomObject]@{ Name = 'TV15Install.log'; FullName = 'C:\TV\TV15Install.log' }
                    [PSCustomObject]@{ Name = 'TVNetwork.log'; FullName = 'C:\TV\TVNetwork.log' }
                )
            }

            Mock Get-ChildItem -ParameterFilter { $Path -eq 'C:\Users\Test\AppData\Local\TeamViewer\Logs' } {
                @(
                    [PSCustomObject]@{ Name = 'file2.log'; FullName = 'C:\Users\Test\AppData\Local\TeamViewer\Logs\file2.log' }
                    [PSCustomObject]@{ Name = 'TVNetwork_Old.log'; FullName = 'C:\Users\Test\AppData\Local\TeamViewer\Logs\TVNetwork_Old.log' }
                )
            }

            Mock Get-ChildItem -ParameterFilter { $Path -eq 'C:\Users\Test\AppData\Roaming\TeamViewer' } {
                @(
                    [PSCustomObject]@{ Name = 'file3.log'; FullName = 'C:\Users\Test\AppData\Roaming\TeamViewer\file3.log' }
                    [PSCustomObject]@{ Name = '1EClient-install.log'; FullName = 'C:\Users\Test\AppData\Roaming\TeamViewer\1EClient-install.log' }
                )
            }
        }

        It 'Should return log file paths from all search directories' {
            $Result = Get-TeamViewerLogFilePath

            $Result | Should -Contain 'C:\TV\file1.log'
            $Result | Should -Contain 'C:\Users\Test\AppData\Local\TeamViewer\Logs\file2.log'
            $Result | Should -Contain 'C:\Users\Test\AppData\Roaming\TeamViewer\file3.log'
            $Result | Should -HaveCount 3
        }

        It 'Should exclude files by name' {
            $Result = Get-TeamViewerLogFilePath

            $Result | Should -Not -Contain 'C:\TV\TV15Install.log'
            $Result | Should -Not -Contain 'C:\TV\TVNetwork.log'
            $Result | Should -Not -Contain 'C:\Users\Test\AppData\Local\TeamViewer\Logs\TVNetwork_Old.log'
            $Result | Should -Not -Contain 'C:\Users\Test\AppData\Roaming\TeamViewer\1EClient-install.log'
        }

        It 'Should only query directories that exist' {
            Get-TeamViewerLogFilePath | Out-Null

            Should -Invoke Test-Path -Exactly -Times 3
            Should -Invoke Get-ChildItem -Exactly -Times 3
        }

        It 'Should query log files only' {
            Get-TeamViewerLogFilePath | Out-Null

            Should -Invoke Get-ChildItem -Exactly -Times 3 -ParameterFilter {
                $Filter -eq '*.log'
            }
        }

        AfterAll {
            $env:APPDATA = $script:OriginalAppData
            $env:LOCALAPPDATA = $script:OriginalLocalAppData
        }
    }

    Context 'When some search directories do not exist' {
        BeforeAll {
            $script:OriginalAppData = $env:APPDATA
            $script:OriginalLocalAppData = $env:LOCALAPPDATA
            $env:APPDATA = 'C:\Users\Test\AppData\Roaming'
            $env:LOCALAPPDATA = 'C:\Users\Test\AppData\Local'

            Mock Test-TeamViewerInstallation { $true }
            Mock Get-TeamViewerInstallationDirectory { 'C:\TV' }
            Mock Test-Path -ParameterFilter { $Path -eq 'C:\TV' } { $true }
            Mock Test-Path -ParameterFilter { $Path -eq 'C:\Users\Test\AppData\Local\TeamViewer\Logs' } { $false }
            Mock Test-Path -ParameterFilter { $Path -eq 'C:\Users\Test\AppData\Roaming\TeamViewer' } { $true }
            Mock Get-ChildItem -ParameterFilter { $Path -eq 'C:\TV' } {
                [PSCustomObject]@{ Name = 'file1.log'; FullName = 'C:\TV\file1.log' }
            }

            Mock Get-ChildItem -ParameterFilter { $Path -eq 'C:\Users\Test\AppData\Roaming\TeamViewer' } {
                [PSCustomObject]@{ Name = 'file2.log'; FullName = 'C:\Users\Test\AppData\Roaming\TeamViewer\file2.log' }
            }
        }

        It 'Should return log file paths from the existing directories only' {
            $Result = Get-TeamViewerLogFilePath

            $Result | Should -Contain 'C:\TV\file1.log'
            $Result | Should -Contain 'C:\Users\Test\AppData\Roaming\TeamViewer\file2.log'
            $Result | Should -HaveCount 2
        }

        AfterAll {
            $env:APPDATA = $script:OriginalAppData
            $env:LOCALAPPDATA = $script:OriginalLocalAppData
        }
    }

    Context 'When no log files are found' {
        BeforeAll {
            Mock Test-TeamViewerInstallation { $true }
            Mock Get-TeamViewerInstallationDirectory { 'C:\TV' }
            Mock Test-Path { $true }
            Mock Get-ChildItem { @() }
        }

        It 'Should return no output' {
            Get-TeamViewerLogFilePath | Should -BeNullOrEmpty
        }
    }

    Context 'When TeamViewer is not installed' {
        BeforeAll {
            Mock Test-TeamViewerInstallation { $false }
            Mock Write-Error {}
        }

        It 'Should write an error message' {
            Get-TeamViewerLogFilePath

            Should -Invoke -CommandName 'Write-Error' -Exactly -Times 1
        }
    }
}
