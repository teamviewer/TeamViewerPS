BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Get-TeamViewerInstallationDirectory.ps1"
    . "$PSScriptRoot\..\..\Cmdlets\Public\Get-TeamViewerInstallationPackage.ps1"
    . "$PSScriptRoot\..\..\Cmdlets\Public\Test-TeamViewerInstallation.ps1"
    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }
}

Describe 'Get-TeamViewerInstallationPackage' {
    BeforeAll {
        Mock Test-TeamViewerInstallation { $true }
        Mock Get-TeamViewerInstallationDirectory { 'testPath' }

        $script:TV_InstallationDirectory = 'testPath'

        $script:testVersionInfo = [PSCustomObject]@{
            ProductName = $null
        }

        $script:testItem = [PSCustomObject]@{}
        $script:testItem | Add-Member -MemberType NoteProperty -Name VersionInfo -Value $script:testVersionInfo

        Mock Get-Item -ParameterFilter {
            $Path -eq (Join-Path -Path 'testPath' -ChildPath 'TeamViewer.exe')
        } { $script:testItem }
    }

    It 'Should map the TeamViewer ProductName to a package type' -TestCases @(
        @{ ProductName = 'TeamViewer Full Client'; Expected = 'Full' }
        @{ ProductName = 'TeamViewer Host Client'; Expected = 'Host' }
        @{ ProductName = 'TeamViewer Something'; Expected = $null }
        @{ ProductName = $null; Expected = $null }
    ) {
        param(
            [object]$ProductName,
            [object]$Expected
        )

        $script:testVersionInfo.ProductName = $ProductName

        $Result = Get-TeamViewerInstallationPackage

        if ($null -eq $Expected) {
            $Result | Should -BeNullOrEmpty
        }
        else {
            $Result | Should -Be $Expected
        }

        Should -Invoke Test-TeamViewerInstallation -Scope It -Times 1
        Should -Invoke Get-Item -Scope It -Times 1 -ParameterFilter {
            $Path -eq (Join-Path -Path 'testPath' -ChildPath 'TeamViewer.exe')
        }
    }

    It 'Should return null when TeamViewer is not installed' {
        Mock Test-TeamViewerInstallation { $false }

        Get-TeamViewerInstallationPackage | Should -BeNullOrEmpty

        Should -Invoke Get-Item -Scope It -Times 0
    }

    It 'Should write a verbose message when installation metadata cannot be read' {
        Mock Get-Item -ParameterFilter {
            $Path -eq (Join-Path -Path 'testPath' -ChildPath 'TeamViewer.exe')
        } { throw 'file not found' }
        Mock Write-Verbose { }

        $Result = Get-TeamViewerInstallationPackage

        $Result | Should -BeNullOrEmpty

        Should -Invoke Write-Verbose -Scope It -Times 1 -ParameterFilter {
            $Message -like 'Failed to read the TeamViewer file attribute information:*'
        }
    }
}
