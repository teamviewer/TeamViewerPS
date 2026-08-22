BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Add-TeamViewerAssignment.ps1"
    . "$PSScriptRoot\..\..\Cmdlets\Public\Get-TeamViewerInstallationDirectory.ps1"
    . "$PSScriptRoot\..\..\Cmdlets\Public\Test-TeamViewerInstallation.ps1"
    . "$PSScriptRoot\..\..\Cmdlets\Public\Get-TeamViewerVersion.ps1"
    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }
}
Describe 'Add-TeamViewerAssignment' {
    BeforeAll {
        Mock Get-TeamViewerInstallationDirectory { 'testPath' }
        Mock Get-TeamViewerVersion { '15.50' }
        Mock Test-TeamViewerInstallation { $true }
        Mock Resolve-TeamViewerAssignmentErrorCode {}
        Mock Start-Process {
            [pscustomobject]@{ ExitCode = 0 }
        }
    }

    It 'Should reject a non-positive retry count' {
        { Add-TeamViewerAssignment -AssignmentId '123' -Retries 0 } | Should -Throw
    }

    It 'Should call TeamViewer.exe assignment with device alias and retries' {
        Mock Start-Process -ParameterFilter {
            $FilePath -eq (Join-Path -Path 'testPath' -ChildPath 'TeamViewer.exe') -and
            $ArgumentList -eq 'assignment --id 123 --device-alias=TestAlias --retries=3'
        } {
            [pscustomobject]@{ ExitCode = 0 }
        }

        Add-TeamViewerAssignment -AssignmentId '123' -DeviceAlias 'TestAlias' -Retries 3

        Should -Invoke Start-Process -Scope It -Times 1
    }

    It 'Should call TeamViewer.exe assignment with device alias' {
        Mock Start-Process -ParameterFilter {
            $FilePath -eq (Join-Path -Path 'testPath' -ChildPath 'TeamViewer.exe') -and
            $ArgumentList -eq 'assignment --id 123 --device-alias=TestAlias'
        } {
            [pscustomobject]@{ ExitCode = 0 }
        }

        Add-TeamViewerAssignment -AssignmentId '123' -DeviceAlias 'TestAlias'

        Should -Invoke Start-Process -Scope It -Times 1
    }

    It 'Should call TeamViewer.exe assignment with retries' {
        Mock Start-Process -ParameterFilter {
            $FilePath -eq (Join-Path -Path 'testPath' -ChildPath 'TeamViewer.exe') -and
            $ArgumentList -eq 'assignment --id 123 --retries=3'
        } {
            [pscustomobject]@{ ExitCode = 0 }
        }

        Add-TeamViewerAssignment -AssignmentId '123' -Retries 3

        Should -Invoke Start-Process -Scope It -Times 1
    }

    It 'Should call TeamViewer.exe assignment without device alias or retries' {
        Mock Start-Process -ParameterFilter {
            $FilePath -eq (Join-Path -Path 'testPath' -ChildPath 'TeamViewer.exe') -and
            $ArgumentList -eq 'assignment --id 123'
        } {
            [pscustomobject]@{ ExitCode = 0 }
        }

        Add-TeamViewerAssignment -AssignmentId '123'

        Should -Invoke Start-Process -Scope It -Times 1
    }

    It 'Should not start the process when WhatIf is used' {
        Add-TeamViewerAssignment -AssignmentId '123' -WhatIf

        Should -Invoke Start-Process -Scope It -Times 0
    }

    It 'Should abort processing when TeamViewer is not installed' {
        Mock Test-TeamViewerInstallation { $false }
        Mock Write-Error {}
        Mock Start-Process {}

        Add-TeamViewerAssignment -AssignmentId '123' -DeviceAlias 'TestAlias'

        Should -Invoke Write-Error -Scope It -Times 1 -ParameterFilter {
            $Message -eq 'TeamViewer is not installed!'
        }

        Should -Invoke Start-Process -Scope It -Times 0
    }

    It 'Should write an error for an unsupported alias version' {
        Mock Get-TeamViewerVersion { '15.43' }
        Mock Write-Error {}

        Add-TeamViewerAssignment -AssignmentId '123' -DeviceAlias 'TestAlias'

        Should -Invoke Write-Error -Scope It -Times 1 -ParameterFilter {
            $Message -eq 'Current TeamViewer version (15.43) does not support the usage of the alias.'
        }
    }

    It 'Should propagate the error from Start-Process' {
        Mock Start-Process { throw 'boom' }

        { Add-TeamViewerAssignment -AssignmentId '123' -DeviceAlias 'TestAlias' } | Should -Throw
    }
}
