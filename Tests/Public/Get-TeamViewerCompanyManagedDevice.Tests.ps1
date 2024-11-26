BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Get-TeamViewerCompanyManagedDevice.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | `
        ForEach-Object { . $_.FullName }

    $testApiToken = [securestring]@{}
    $null = $testApiToken

    Mock Get-TeamViewerApiUri { '//unit.test' }
}

Describe 'Get-TeamViewerCompanyManagedDevice' {
    Context 'AllDevices' {
        BeforeAll {
            Mock Invoke-TeamViewerRestMethod { @{
                    nextPaginationToken = $null
                    resources           = @(
                        @{ id = 'ae222e9d-a665-4cea-85b7-d4a3a08a5e35'; name = 'test company-managed device 1' },
                        @{ id = '6cbfcfb2-a929-4987-a91b-89e2945412cf'; name = 'test company-managed device 2' },
                        @{ id = '99a87bed-3d60-46f2-a869-b7e67a6bf2c8'; name = 'test company-managed device 3' }
                    )
                } }
        }

        It 'Should call the correct API endpoint to list company-managed devices' {
            Get-TeamViewerCompanyManagedDevice -ApiToken $testApiToken

            $base_test_path = '//unit.test'
            $desired_endpoint = 'managed/devices/company'

            Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
                $ApiToken -eq $testApiToken -And `
                    $Uri -eq "$base_test_path/$desired_endpoint" -And `
                    $Method -eq 'Get' }
        }

        It 'Should return ManagedDevice objects' {
            $result = Get-TeamViewerCompanyManagedDevice -ApiToken $testApiToken
            $result | Should -HaveCount 3
            $result[0].PSObject.TypeNames | Should -Contain 'TeamViewerPS.ManagedDevice'
        }

        It 'Should fetch consecutive pages' {
            Mock Invoke-TeamViewerRestMethod { @{
                    nextPaginationToken = 'abc'
                    resources           = @(
                        @{ id = 'ae222e9d-a665-4cea-85b7-d4a3a08a5e35'; name = 'test company-managed device 1' },
                        @{ id = '6cbfcfb2-a929-4987-a91b-89e2945412cf'; name = 'test company-managed device 2' },
                        @{ id = '99a87bed-3d60-46f2-a869-b7e67a6bf2c8'; name = 'test company-managed device 3' }
                    )
                } }
            Mock Invoke-TeamViewerRestMethod { @{
                    nextPaginationToken = $null
                    resources           = @(
                        @{ id = '76e699b7-2559-4202-bf7b-c6af6929aa15'; name = 'test company-managed device 4' }
                    )
                } } -ParameterFilter { $Body -And $Body['paginationToken'] -eq 'abc' }

            $result = Get-TeamViewerCompanyManagedDevice -ApiToken $testApiToken
            $result | Should -HaveCount 4

            Assert-MockCalled Invoke-TeamViewerRestMethod -Times 2 -Scope It
        }
    }
}
