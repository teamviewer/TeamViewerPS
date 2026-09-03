BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Get-TeamViewerManagedDevice.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }

    $testApiToken = [securestring]@{}
    $null = $testApiToken

    Mock Get-TeamViewerApiUri { '//unit.test' }
}

Describe 'Get-TeamViewerManagedDevice' {
    Context 'List' {
        BeforeAll {
            Mock Invoke-TeamViewerRestMethod { @{
                    nextPaginationToken = $null
                    resources           = @(
                        @{ id = 'ae222e9d-a665-4cea-85b7-d4a3a08a5e35'; name = 'test managed device 1' },
                        @{ id = '6cbfcfb2-a929-4987-a91b-89e2945412cf'; name = 'test managed device 2' },
                        @{ id = '99a87bed-3d60-46f2-a869-b7e67a6bf2c8'; name = 'test managed device 3' }
                    )
                } }
        }

        It 'Should call the correct API endpoint to list managed devices' {
            Get-TeamViewerManagedDevice -ApiToken $testApiToken

            Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
                $ApiToken -eq $testApiToken -and $Uri -eq '//unit.test/managed/devices' -and $Method -eq 'Get' }
        }

        It 'Should return ManagedDevice objects' {
            $Result = Get-TeamViewerManagedDevice -ApiToken $testApiToken
            $Result | Should -HaveCount 3
            $Result[0].PSObject.TypeNames | Should -Contain 'TeamViewerPS.ManagedDevice'
        }

        It 'Should fetch consecutive pages' {
            Mock Invoke-TeamViewerRestMethod { @{
                    nextPaginationToken = 'abc'
                    resources           = @(
                        @{ id = 'ae222e9d-a665-4cea-85b7-d4a3a08a5e35'; name = 'test managed device 1' },
                        @{ id = '6cbfcfb2-a929-4987-a91b-89e2945412cf'; name = 'test managed device 2' },
                        @{ id = '99a87bed-3d60-46f2-a869-b7e67a6bf2c8'; name = 'test managed device 3' }
                    )
                } }

            Mock Invoke-TeamViewerRestMethod { @{
                    nextPaginationToken = $null
                    resources           = @(
                        @{ id = '76e699b7-2559-4202-bf7b-c6af6929aa15'; name = 'test managed device 4' }
                    )
                } } -ParameterFilter { $Body -and $Body['paginationToken'] -eq 'abc' }

            $Result = Get-TeamViewerManagedDevice -ApiToken $testApiToken
            $Result | Should -HaveCount 4

            Should -Invoke Invoke-TeamViewerRestMethod -Times 2 -Scope It
        }
    }

    Context 'Single Managed Device' {
        BeforeAll {
            Mock Invoke-TeamViewerRestMethod { @{
                    id   = 'ae222e9d-a665-4cea-85b7-d4a3a08a5e35'
                    name = 'test managed device 1'
                } }
        }

        It 'Should call the correct API endpoint for single managed group' {
            Get-TeamViewerManagedDevice -ApiToken $testApiToken -Device 'ae222e9d-a665-4cea-85b7-d4a3a08a5e35'

            Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
                $ApiToken -eq $testApiToken -and $Uri -eq '//unit.test/managed/devices/ae222e9d-a665-4cea-85b7-d4a3a08a5e35' -and $Method -eq 'Get' }
        }

        It 'Should return a ManagedDevice object' {
            $Result = Get-TeamViewerManagedDevice -ApiToken $testApiToken -Device 'ae222e9d-a665-4cea-85b7-d4a3a08a5e35'
            $Result | Should -BeOfType ([pscustomobject])
            $Result.PSObject.TypeNames | Should -Contain 'TeamViewerPS.ManagedDevice'
        }
    }

    Context 'List Group Devices' {
        BeforeAll {
            $testGroupId = '9e5617cb-2b20-4da2-bca4-c1bda85b29ab'
            $null = $testGroupId

            Mock Invoke-TeamViewerRestMethod { @{
                    nextPaginationToken = $null
                    resources           = @(
                        @{
                            id           = '9cff5beb-45c1-4260-a40b-4a0c633f5330'
                            name         = 'test device 1'
                            teamviewerId = 12345678
                            isOnline     = $false
                            last_seen    = '2023-02-03T11:14:19Z'
                        },
                        @{
                            id           = 'bc76c466-50dc-4b1f-963d-9b3a10a40ec6'
                            name         = 'test device 2'
                            teamviewerId = 87654321
                            isOnline     = $true
                            last_seen    = '2023-02-03T11:14:19Z'
                        }
                    )
                } }
        }

        It 'Should call the correct API endpoint to list managed group devices' {
            Get-TeamViewerManagedDevice -ApiToken $testApiToken -GroupId $testGroupId

            Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
                $ApiToken -eq $testApiToken -and $Uri -eq "//unit.test/managed/groups/$testGroupId/devices" -and $Method -eq 'Get' }
        }

        It 'Should return ManagedDevice objects' {
            $Result = Get-TeamViewerManagedDevice -ApiToken $testApiToken -GroupId $testGroupId
            $Result | Should -HaveCount 2
            $Result[0].PSObject.TypeNames | Should -Contain 'TeamViewerPS.ManagedDevice'
            $Result[0].Name | Should -Be 'test device 1'
        }

        It 'Should handle group objects as input' {
            $testGroup = @{id = $testGroupId; name = 'test managed group' } | ConvertTo-TeamViewerManagedGroup

            Get-TeamViewerManagedDevice -ApiToken $testApiToken -Group $testGroup

            Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
                $ApiToken -eq $testApiToken -and $Uri -eq "//unit.test/managed/groups/$testGroupId/devices" -and $Method -eq 'Get' }
        }

        It 'Should fetch consecutive pages' {
            Mock Invoke-TeamViewerRestMethod { @{
                    nextPaginationToken = 'abc'
                    resources           = @(
                        @{
                            id           = '9cff5beb-45c1-4260-a40b-4a0c633f5330'
                            name         = 'test device 1'
                            teamviewerId = 12345678
                            isOnline     = $false
                            last_seen    = '2023-02-03T11:14:19Z'
                        },
                        @{
                            id           = 'bc76c466-50dc-4b1f-963d-9b3a10a40ec6'
                            name         = 'test device 2'
                            teamviewerId = 87654321
                            isOnline     = $true
                            last_seen    = '2023-02-03T11:14:19Z'
                        }
                    )
                } }

            Mock Invoke-TeamViewerRestMethod { @{
                    nextPaginationToken = $null
                    resources           = @(
                        @{
                            id           = 'f1f7f892-f18b-4236-9e9b-2516fd2d4865'
                            name         = 'test device 3'
                            teamviewerId = 12345678
                            isOnline     = $false
                            last_seen    = '2023-02-03T11:14:19Z'
                        }
                    )
                } } -ParameterFilter { $Body -and $Body['paginationToken'] -eq 'abc' }

            $Result = Get-TeamViewerManagedDevice -ApiToken $testApiToken -GroupId $testGroupId
            $Result | Should -HaveCount 3

            Should -Invoke Invoke-TeamViewerRestMethod -Times 2 -Scope It
        }

        It 'Should call the correct API endpoint to list managed group pending devices' {
            Get-TeamViewerManagedDevice -ApiToken $testApiToken -GroupId $testGroupId -FilterBy_Pending

            Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
                $ApiToken -eq $testApiToken -and $Uri -eq "//unit.test/managed/groups/$testGroupId/pending-devices" -and $Method -eq 'Get' }
        }
    }
}
