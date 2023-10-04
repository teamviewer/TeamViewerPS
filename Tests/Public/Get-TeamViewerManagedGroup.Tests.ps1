BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Get-TeamViewerManagedGroup.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | `
        ForEach-Object { . $_.FullName }

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

            Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
                $ApiToken -eq $testApiToken -And `
                    $Uri -eq '//unit.test/managed/groups' -And `
                    $Method -eq 'Get' }
        }

        It 'Should return ManagedGroup objects' {
            $result = Get-TeamViewerManagedGroup -ApiToken $testApiToken
            $result | Should -HaveCount 3
            $result[0].PSObject.TypeNames | Should -Contain 'TeamViewerPS.ManagedGroup'
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
                } } -ParameterFilter { $Body -And $Body['paginationToken'] -eq 'abc' }

            $result = Get-TeamViewerManagedGroup -ApiToken $testApiToken
            $result | Should -HaveCount 4

            Assert-MockCalled Invoke-TeamViewerRestMethod -Times 2 -Scope It
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

            Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
                $ApiToken -eq $testApiToken -And `
                    $Uri -eq '//unit.test/managed/groups/ae222e9d-a665-4cea-85b7-d4a3a08a5e35' -And `
                    $Method -eq 'Get' }
        }

        It 'Should return a ManagedGroup object' {
            $result = Get-TeamViewerManagedGroup -ApiToken $testApiToken -Group 'ae222e9d-a665-4cea-85b7-d4a3a08a5e35'
            $result | Should -BeOfType PSObject
            $result.PSObject.TypeNames | Should -Contain 'TeamViewerPS.ManagedGroup'
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
            Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
                $ApiToken -eq $testApiToken -And `
                    $Uri -eq "//unit.test/managed/devices/$testDeviceId/groups" -And `
                    $Method -eq 'Get' }
        }

        It 'Should return managed groups objects' {
            $result = Get-TeamViewerManagedGroup -ApiToken $testApiToken -Device $testDeviceId
            $result | Should -HaveCount 3
            $firstResult = $result[0]
            $firstResult | Should -BeOfType PSObject
            $firstResult.PSObject.TypeNames | Should -Contain 'TeamViewerPS.ManagedGroup'
        }

        It 'Should accept a ManagedDevice object as input' {
            $testDevice = @{ id = $testDeviceId; name = 'test device' } | ConvertTo-TeamViewerManagedDevice
            Get-TeamViewerManagedGroup -ApiToken $testApiToken -Device $testDevice
            Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
                $ApiToken -eq $testApiToken -And `
                    $Uri -eq "//unit.test/managed/devices/$testDeviceId/groups" -And `
                    $Method -eq 'Get' }
        }
    }
}
