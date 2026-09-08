BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Get-TeamViewerUserByRole.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }

    Mock Get-TeamViewerAPIUri { '//unit.test' }
    $Assigned = @('u201', 'u202')
    Mock Invoke-TeamViewerRestMethod { @{
            ContinuationToken = $null
            AssignedToUsers   = $Assigned
        } }

    $testAPIToken = [securestring]@{}
    $null = $testAPIToken
    $testRoleId = '72abbedc-9853-4fc8-9d28-fa35e207b048'
    $null = $testRoleId
}

Describe 'Get-TeamViewerUserByRole' {
    Context 'When retrieving role assignments' {
        It 'Should call the correct API endpoint' {
            Get-TeamViewerUserByRole -APIToken $testAPIToken -Role $testRoleId

            Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
                $APIToken -eq $testAPIToken -and $Uri -eq "//unit.test/userroles/assignments/account?userRoleId=$testRoleId" -and $Method -eq 'Get'
            }
        }

        It 'Should return assigned users' {
            $Result = Get-TeamViewerUserByRole -APIToken $testAPIToken -Role $testRoleId
            $Result | Should -HaveCount 2
        }

        It 'Should follow pagination without accumulating continuation tokens' {
            $Responses = [System.Collections.Queue]::new()
            $Responses.Enqueue([PSCustomObject]@{ ContinuationToken = 'page2'; AssignedToUsers = @('u1') })
            $Responses.Enqueue([PSCustomObject]@{ ContinuationToken = 'page3'; AssignedToUsers = @('u2') })
            $Responses.Enqueue([PSCustomObject]@{ ContinuationToken = $null; AssignedToUsers = @('u3') })
            Mock Invoke-TeamViewerRestMethod -MockWith { $Responses.Dequeue() }

            $Result = Get-TeamViewerUserByRole -APIToken $testAPIToken -Role $testRoleId

            $Result | Should -HaveCount 3
            Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
                $Uri -eq "//unit.test/userroles/assignments/account?userRoleId=$testRoleId&continuationToken=page2"
            }
            Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
                $Uri -eq "//unit.test/userroles/assignments/account?userRoleId=$testRoleId&continuationToken=page3"
            }
        }

    }
}
