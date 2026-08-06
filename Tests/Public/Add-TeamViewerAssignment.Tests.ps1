BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Add-TeamViewerAssignment.ps1"
    . "$PSScriptRoot\..\..\Cmdlets\Public\Get-TeamViewerInstallationDirectory.ps1"
    . "$PSScriptRoot\..\..\Cmdlets\Public\Test-TeamViewerInstallation.ps1"
    . "$PSScriptRoot\..\..\Cmdlets\Public\Get-TeamViewerVersion.ps1"
    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | `
        ForEach-Object { . $_.FullName }
}
Describe 'Add-TeamViewerAssignment' {
    BeforeAll {
        # Testing independent behavior using mocked dependencies
        Mock Get-TeamViewerInstallationDirectory { 'testPath' }
        Mock Get-TeamViewerVersion { '15.50' }
        Mock Test-TeamViewerInstallation { $true }
        Mock Set-Location {}
        Mock Start-Process {}
        Mock Resolve-AssignmentErrorCode {}
        Mock Start-Process {
            $process = New-Object PSObject -Property @{
                ExitCode = 0
            }
            $process
        }
    }

    It 'Should set the location to the installation directory' {
        Add-TeamViewerAssignment -AssignmentId '123' -DeviceAlias 'TestAlias' -Retries 3
        Should -Invoke Set-Location -Scope It -Times 1 -ParameterFilter {
            $Path -eq 'testPath'
        }
    }

    It 'Should call TeamViewer.exe assignment with device alias and retries' {
        Mock Start-Process -ParameterFilter { $_.FilePath -eq 'TeamViewer.exe' -and $_.ArgumentList -eq 'assignment --id 123 --device-alias=TestAlias --retries=3' }
        Add-TeamViewerAssignment -AssignmentId '123' -DeviceAlias 'TestAlias' -Retries 3
        Should -Invoke Start-Process -Scope It -Times 1
    }

    It 'Should call TeamViewer.exe assignment with device alias' {
        Mock Start-Process -ParameterFilter { $_.FilePath -eq 'TeamViewer.exe' -and $_.ArgumentList -eq 'assignment --id 123 --device-alias=TestAlias' }
        Add-TeamViewerAssignment -AssignmentId '123' -DeviceAlias 'TestAlias'
        Should -Invoke Start-Process -Scope It -Times 1
    }

    It 'Should call TeamViewer.exe assignment with retries' {
        Mock Start-Process -ParameterFilter { $_.FilePath -eq 'TeamViewer.exe' -and $_.ArgumentList -eq 'assignment --id 123 --retries=3' }
        Add-TeamViewerAssignment -AssignmentId '123' -Retries 3
        Should -Invoke Start-Process -Scope It -Times 1
    }

    It 'Should call TeamViewer.exe assignment without device alias or retries' {
        Mock Start-Process -ParameterFilter { $_.FilePath -eq 'TeamViewer.exe' -and $_.ArgumentList -eq 'assignment --id 123' }
        Add-TeamViewerAssignment -AssignmentId '123'
        Should -Invoke Start-Process -Scope It -Times 1
    }

    It 'Should restore the current directory after calling cmd.exe' {
        $currentDirectory = Get-Location
        Add-TeamViewerAssignment -AssignmentId '123' -DeviceAlias 'TestAlias'
        Should -Invoke Set-Location -Scope It -Times 1 -ParameterFilter {
            $Path -eq $currentDirectory
        }
    }
}
