
Describe 'Get-TeamViewerUserByRole' {
    Context 'When retrieving role assignments' {
        BeforeEach {
            . "$PSScriptRoot\..\..\Cmdlets\Public\Get-TeamViewerRoleByUser.ps1"

            @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | `
                ForEach-Object { . $_.FullName }

            Mock Get-TeamViewerApiUri { '//unit.test' }
            $responses = [System.Collections.Queue]::new()
            $responses.Enqueue([PSCustomObject]@{
                    currentPaginationToken = $null
                    nextPaginationToken    = 'Test1'
                    assignedRoleIds        = @('f37001f9-bc3e-452e-9533-d81b0916be09')
                })
            $responses.Enqueue([PSCustomObject]@{
                    currentPaginationToken = $null
                    nextPaginationToken    = $null
                    assignedRoleIds        = @('f47001f9-bc3e-452e-9533-d81b0916be09')
                })
            Mock Invoke-TeamViewerRestMethod -MockWith {
                if ($responses.Count -gt 0) {
                    return $responses.Dequeue()
                }
            }
            $testApiToken = [securestring]@{}
            $null = $testApiToken
            $testUserId = 'u123456777'
            $null = $testUserId
        }
        It 'Should call the correct API endpoint' {
            Get-TeamViewerRoleByUser -ApiToken $testApiToken -UserId $testUserId

            Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
                $ApiToken -eq $testApiToken -And `
                    $Uri -eq "//unit.test/users/$testUserId/userroles?paginationToken=Test1" -And `
                    $Method -eq 'Get' 
            }
        }
        It 'Should return assigned users' {
            $result = Get-TeamViewerRoleByUser -ApiToken $testApiToken -UserId $testUserId
            $result | Should -HaveCount 2
        }
        It 'Should return an empty list if no roles are assigned' {
            Mock Invoke-TeamViewerRestMethod -MockWith {
                [PSCustomObject]@{
                    currentPaginationToken = $null
                    nextPaginationToken    = $null
                    assignedRoleIds        = @()
                }
            }
            $result = Get-TeamViewerRoleByUser -ApiToken $testApiToken -UserId $testUserId
            $result | Should -HaveCount 0
        }
    }
}
