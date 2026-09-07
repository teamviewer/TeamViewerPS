
Describe 'Get-TeamViewerUserByRole' {
    Context 'When retrieving role assignments' {
        BeforeEach {
            . "$PSScriptRoot\..\..\Cmdlets\Public\Get-TeamViewerRoleByUser.ps1"

            @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }

            Mock Get-TeamViewerAPIUri { '//unit.test' }
            $Responses = [System.Collections.Queue]::new()
            $Responses.Enqueue([PSCustomObject]@{
                    currentPaginationToken = $null
                    nextPaginationToken    = 'Test1'
                    assignedRoleIds        = @('f37001f9-bc3e-452e-9533-d81b0916be09')
                })
            $Responses.Enqueue([PSCustomObject]@{
                    currentPaginationToken = $null
                    nextPaginationToken    = $null
                    assignedRoleIds        = @('f47001f9-bc3e-452e-9533-d81b0916be09')
                })

            Mock Invoke-TeamViewerRestMethod -MockWith {
                if ($Responses.Count -gt 0) {
                    return $Responses.Dequeue()
                }
            }

            $testAPIToken = [securestring]@{}
            $null = $testAPIToken
            $testUserId = 'u123456777'
            $null = $testUserId
        }

        It 'Should call the correct API endpoint' {
            Get-TeamViewerRoleByUser -APIToken $testAPIToken -UserId $testUserId

            Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
                $APIToken -eq $testAPIToken -and $Uri -eq "//unit.test/users/$testUserId/userroles?paginationToken=Test1" -and $Method -eq 'Get'
            }
        }

        It 'Should return assigned users' {
            $Result = Get-TeamViewerRoleByUser -APIToken $testAPIToken -UserId $testUserId
            $Result | Should -HaveCount 2
            $Result[0].PSObject.TypeNames[0] | Should -Be 'TeamViewerPS.UserAssignedRole'
            $Result[0].Role_Id | Should -Be 'f37001f9-bc3e-452e-9533-d81b0916be09'
        }

        It 'Should return an empty list if no roles are assigned' {
            Mock Invoke-TeamViewerRestMethod -MockWith {
                [PSCustomObject]@{
                    currentPaginationToken = $null
                    nextPaginationToken    = $null
                    assignedRoleIds        = @()
                }
            }

            $Result = Get-TeamViewerRoleByUser -APIToken $testAPIToken -UserId $testUserId
            $Result | Should -HaveCount 0
        }
    }
}
