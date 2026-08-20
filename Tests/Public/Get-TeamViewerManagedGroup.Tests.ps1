BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Get-TeamViewerManagedGroup.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }

    $testApiToken = [securestring]@{}
    $null = $testApiToken

    Mock Get-TeamViewerApiUri { '//unit.test' }
}

Describe 'Get-TeamViewerManagedGroup' {
    Context 'List' {
        BeforeAll {
            Mock Invoke-TeamViewerRestMethod { @{
                    nextPaginationToken = $null
                    resources           = @(
                        @{ id = 'ae222e9d-a665-4cea-85b7-d4a3a08a5e35'; name = 'test managed group 1' },
                        @{ id = '6cbfcfb2-a929-4987-a91b-89e2945412cf'; name = 'test managed group 2' },
                        @{ id = '99a87bed-3d60-46f2-a869-b7e67a6bf2c8'; name = 'test managed group 3' }
                    )
                } }
        }

        It 'Should call the correct API endpoint to list managed groups' {
            Get-TeamViewerManagedGroup -ApiToken $testApiToken

            Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
                $ApiToken -eq $testApiToken -and $Uri -eq '//unit.test/managed/groups' -and $Method -eq 'Get' }
        }

        It 'Should return ManagedGroup objects' {
            $Result = Get-TeamViewerManagedGroup -ApiToken $testApiToken
            $Result | Should -HaveCount 3
            $Result[0].PSObject.TypeNames | Should -Contain 'TeamViewerPS.ManagedGroup'
        }

        It 'Should fetch consecutive pages' {
            Mock Invoke-TeamViewerRestMethod { @{
                    nextPaginationToken = 'abc'
                    resources           = @(
                        @{ id = 'ae222e9d-a665-4cea-85b7-d4a3a08a5e35'; name = 'test managed group 1' },
                        @{ id = '6cbfcfb2-a929-4987-a91b-89e2945412cf'; name = 'test managed group 2' },
                        @{ id = '99a87bed-3d60-46f2-a869-b7e67a6bf2c8'; name = 'test managed group 3' }
                    )
                } }

            Mock Invoke-TeamViewerRestMethod { @{
                    nextPaginationToken = $null
                    resources           = @(
                        @{ id = '76e699b7-2559-4202-bf7b-c6af6929aa15'; name = 'test managed group 4' }
                    )
                } } -ParameterFilter { $Body -and $Body['paginationToken'] -eq 'abc' }

            $Result = Get-TeamViewerManagedGroup -ApiToken $testApiToken
            $Result | Should -HaveCount 4

            Should -Invoke Invoke-TeamViewerRestMethod -Times 2 -Scope It
        }
    }

    Context 'Single Managed Group' {
        BeforeAll {
            Mock Invoke-TeamViewerRestMethod { @{
                    id   = 'ae222e9d-a665-4cea-85b7-d4a3a08a5e35'
                    name = 'test managed group 1'
                } }
        }

        It 'Should call the correct API endpoint for single managed group' {
            Get-TeamViewerManagedGroup -ApiToken $testApiToken -Group 'ae222e9d-a665-4cea-85b7-d4a3a08a5e35'

            Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
                $ApiToken -eq $testApiToken -and $Uri -eq '//unit.test/managed/groups/ae222e9d-a665-4cea-85b7-d4a3a08a5e35' -and $Method -eq 'Get' }
        }

        It 'Should return a ManagedGroup object' {
            $Result = Get-TeamViewerManagedGroup -ApiToken $testApiToken -Group 'ae222e9d-a665-4cea-85b7-d4a3a08a5e35'
            $Result | Should -BeOfType ([pscustomobject])
            $Result.PSObject.TypeNames | Should -Contain 'TeamViewerPS.ManagedGroup'
        }
    }

    Context 'List device managed groups' {
        BeforeAll {
            Mock Invoke-TeamViewerRestMethod { @{
                    nextPaginationToken = $null
                    resources           = @(
                        @{ id = 'ae222e9d-a665-4cea-85b7-d4a3a08a5e35'; name = 'test managed group 1' },
                        @{ id = '6cbfcfb2-a929-4987-a91b-89e2945412cf'; name = 'test managed group 2' },
                        @{ id = '99a87bed-3d60-46f2-a869-b7e67a6bf2c8'; name = 'test managed group 3' }
                    )
                } }
            $testDeviceId = 'bbeedb62-51a3-4842-8ec2-386f2d8779d8'
            $null = $testDeviceId
        }

        It 'Should call the correct API endpoint to fetch the list of groups that the device is part of' {
            Get-TeamViewerManagedGroup -ApiToken $testApiToken -Device $testDeviceId

            Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
                $ApiToken -eq $testApiToken -and $Uri -eq "//unit.test/managed/devices/$testDeviceId/groups" -and $Method -eq 'Get' }
        }

        It 'Should return managed groups objects' {
            $Result = Get-TeamViewerManagedGroup -ApiToken $testApiToken -Device $testDeviceId
            $Result | Should -HaveCount 3
            $firstResult = $Result[0]
            $firstResult | Should -BeOfType ([pscustomobject])
            $firstResult.PSObject.TypeNames | Should -Contain 'TeamViewerPS.ManagedGroup'
        }

        It 'Should accept a ManagedDevice object as input' {
            $testDevice = @{ id = $testDeviceId; name = 'test device' } | ConvertTo-TeamViewerManagedDevice

            Get-TeamViewerManagedGroup -ApiToken $testApiToken -Device $testDevice

            Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
                $ApiToken -eq $testApiToken -and $Uri -eq "//unit.test/managed/devices/$testDeviceId/groups" -and $Method -eq 'Get' }
        }
    }
}
