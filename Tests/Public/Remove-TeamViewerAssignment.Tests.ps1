BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Remove-TeamViewerAssignment.ps1"
    . "$PSScriptRoot\..\..\Cmdlets\Public\Get-TeamViewerInstallationDirectory.ps1"
    . "$PSScriptRoot\..\..\Cmdlets\Public\Get-TeamViewerVersion.ps1"
    . "$PSScriptRoot\..\..\Cmdlets\Public\Test-TeamViewerInstallation.ps1"
    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }
}
Describe 'Remove-TeamViewerAssignment' {
    BeforeAll {
        Mock Get-TeamViewerInstallationDirectory { 'testPath' }
        Mock Test-TeamViewerInstallation { $true }
        Mock Resolve-TeamViewerAssignmentErrorCode {}
        Mock Start-Process {
            [pscustomobject]@{ ExitCode = 0 }
        }
    }

    It 'Should call TeamViewer.exe unassignment' {
        Mock Start-Process -ParameterFilter {
            $FilePath -eq (Join-Path -Path 'testPath' -ChildPath 'TeamViewer.exe') -and
            $ArgumentList -eq 'unassign'
        } {
            [pscustomobject]@{ ExitCode = 0 }
        }

        Remove-TeamViewerAssignment

        Should -Invoke Start-Process -Scope It -Times 1
    }

    It 'Should not start the process when WhatIf is used' {
        Remove-TeamViewerAssignment -WhatIf

        Should -Invoke Start-Process -Scope It -Times 0
    }

    It 'Should abort processing when TeamViewer is not installed' {
        Mock Test-TeamViewerInstallation { $false }
        Mock Get-TeamViewerInstallationDirectory { 'testPath' }
        Mock Write-Error {}
        Mock Start-Process {}

        Remove-TeamViewerAssignment

        Should -Invoke Write-Error -Scope It -Times 1 -ParameterFilter {
            $Message -eq 'TeamViewer is not installed!'
        }
        Should -Invoke Start-Process -Scope It -Times 0
    }

    It 'Should propagate errors from Start-Process' {
        Mock Start-Process { throw 'boom' }

        { Remove-TeamViewerAssignment } | Should -Throw
    }
}
