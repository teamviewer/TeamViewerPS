BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Remove-TeamViewerAssignment.ps1"
    . "$PSScriptRoot\..\..\Cmdlets\Public\Get-TeamViewerInstallationDirectory.ps1"
    . "$PSScriptRoot\..\..\Cmdlets\Public\Get-TeamViewerVersion.ps1"
    . "$PSScriptRoot\..\..\Cmdlets\Public\Test-TeamViewerInstallation.ps1"
    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | `
        ForEach-Object { . $_.FullName }
}
Describe 'Remove-TeamViewerAssignment' {
    Context 'Windows' {
        BeforeAll {
            # Testing independent behavior using mocked dependencies
            Mock Get-TeamViewerInstallationDirectory { 'testPath' }
            Mock Get-TeamViewerVersion { '15.50' }
            Mock Test-TeamViewerInstallation { $true }
            Mock Set-Location {}
            Mock Start-Process {
                $process = New-Object PSObject -Property @{
                    ExitCode = 0
                }
                $process
            }
            Mock Resolve-AssignmentErrorCode {}
        }

        It 'Should set the location to the installation directory' {
            Remove-TeamViewerAssignment
            Assert-MockCalled Set-Location -Scope It -Times 1 -ParameterFilter {
                $Path -eq 'testPath'
            }
        }


        It 'Should call TeamViewer.exe unassignment' {
            Mock Start-Process -ParameterFilter { $_.FilePath -eq 'TeamViewer.exe' -and $_.ArgumentList -eq 'unassign' }
            Remove-TeamViewerAssignment
            Assert-MockCalled Start-Process -Scope It -Times 1
        }

        It 'Should restore the current directory after calling cmd.exe' {
            Mock cmd.exe {}
            $currentDirectory = Get-Location
            Remove-TeamViewerAssignment
            Assert-MockCalled Set-Location -Scope It -Times 1 -ParameterFilter {
                $Path -eq $currentDirectory
            }
        }
    }
}
