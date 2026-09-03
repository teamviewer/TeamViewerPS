BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Get-TeamViewerPolicy.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }

    $testApiToken = [securestring]@{}
    $null = $testApiToken

    Mock Get-TeamViewerApiUri { '//unit.test' }
}

Describe 'Get-TeamViewerPolicy' {
    Context 'List' {
        BeforeAll {
            Mock Invoke-TeamViewerRestMethod { @{
                    policies = @(
                        @{ policy_id = 'ae222e9d-a665-4cea-85b7-d4a3a08a5e35'; name = 'test policy 1' },
                        @{ policy_id = '6cbfcfb2-a929-4987-a91b-89e2945412cf'; name = 'test policy 2' },
                        @{ policy_id = '99a87bed-3d60-46f2-a869-b7e67a6bf2c8'; name = 'test policy 3' }
                    )
                } }
        }

        It 'Should call the correct API endpoint to list policies' {
            Get-TeamViewerPolicy -ApiToken $testApiToken

            Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
                $ApiToken -eq $testApiToken -and `
                    $Uri -eq '//unit.test/teamviewerpolicies' -and `
                    $Method -eq 'Get' }
        }

        It 'Should return policy objects' {
            $Result = Get-TeamViewerPolicy -ApiToken $testApiToken
            $Result | Should -HaveCount 3
            $Result[0].PSObject.TypeNames | Should -Contain 'TeamViewerPS.Policy'
        }
    }

    Context 'Single Policy' {
        BeforeAll {
            Mock Invoke-TeamViewerRestMethod { @{
                    policies = @(
                        @{ policy_id = 'ae222e9d-a665-4cea-85b7-d4a3a08a5e35'; name = 'test policy 1' }
                    )
                } }
        }

        It 'Should call the correct API endpoint for single policy' {
            Get-TeamViewerPolicy -ApiToken $testApiToken -Id 'ae222e9d-a665-4cea-85b7-d4a3a08a5e35'

            Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
                $ApiToken -eq $testApiToken -and $Uri -eq '//unit.test/teamviewerpolicies/ae222e9d-a665-4cea-85b7-d4a3a08a5e35' -and $Method -eq 'Get' }
        }

        It 'Should return a Policy object' {
            $Result = Get-TeamViewerPolicy -ApiToken $testApiToken -Id 'ae222e9d-a665-4cea-85b7-d4a3a08a5e35'
            $Result | Should -BeOfType ([pscustomobject])
            $Result.PSObject.TypeNames | Should -Contain 'TeamViewerPS.Policy'
        }
    }
}
