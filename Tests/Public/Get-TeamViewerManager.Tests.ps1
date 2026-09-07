BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Get-TeamViewerManager.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }

    $testAPIToken = [securestring]@{}
    $null = $testAPIToken
    $testGroupId = '9e5617cb-2b20-4da2-bca4-c1bda85b29ab'
    $null = $testGroupId
    $testDeviceId = 'e04aa905-1255-4056-93dd-6a1d19c8480d'
    $null = $testDeviceId

    Mock Get-TeamViewerAPIUri { '//unit.test' }
    Mock Invoke-TeamViewerRestMethod { @{
            resources = @(
                @{
                    id          = '53dfe7bd-1073-476d-99bb-27291e463dc4'
                    name        = 'test manager 1'
                    type        = 'account'
                    accountId   = 1234
                    permissions = @('ManagerAdministration', 'EasyAccess')
                },
                @{
                    id          = '7624b56d-8f38-4a7b-a37b-86519789eefe'
                    name        = 'test manager 2'
                    type        = 'company'
                    companyId   = 5678
                    permissions = @('ManagerAdministration')
                }
            )
        } }
}

Describe 'Get-TeamViewerManager' {
    Context 'List Group Managers' {
        It 'Should call the correct API endpoint to list managed group managers' {
            Get-TeamViewerManager -APIToken $testAPIToken -GroupId $testGroupId

            Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
                $APIToken -eq $testAPIToken -and $Uri -eq "//unit.test/managed/groups/$testGroupId/managers" -and $Method -eq 'Get' }
        }

        It 'Should return Manager objects' {
            $Result = Get-TeamViewerManager -APIToken $testAPIToken -GroupId $testGroupId
            $Result | Should -HaveCount 2
            $Result[0].PSObject.TypeNames | Should -Contain 'TeamViewerPS.Manager'
            $Result[0].Name | Should -Be 'test manager 1'
            $Result[0].Group_Id | Should -Be $testGroupId
        }

        It 'Should handle group objects as input' {
            $testGroup = @{id = $testGroupId; name = 'test managed group' } | ConvertTo-TeamViewerManagedGroup
            $Result = Get-TeamViewerManager -APIToken $testAPIToken -Group $testGroup
            $Result | Should -HaveCount 2
            $Result[0].Group_Id | Should -Be $testGroupId
        }
    }

    Context 'List Device Managers' {
        It 'Should call the correct API endpoint to list managed device managers' {
            Get-TeamViewerManager -APIToken $testAPIToken -DeviceId $testDeviceId

            Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
                $APIToken -eq $testAPIToken -and $Uri -eq "//unit.test/managed/devices/$testDeviceId/managers" -and $Method -eq 'Get' }
        }

        It 'Should return Manager objects' {
            $Result = Get-TeamViewerManager -APIToken $testAPIToken -DeviceId $testDeviceId
            $Result | Should -HaveCount 2
            $Result[0].PSObject.TypeNames | Should -Contain 'TeamViewerPS.Manager'
            $Result[0].Name | Should -Be 'test manager 1'
            $Result[0].Device_Id | Should -Be $testDeviceId
        }

        It 'Should handle device objects as input' {
            $testDevice = @{id = $testDeviceId; name = 'test managed device' } | ConvertTo-TeamViewerManagedDevice
            $Result = Get-TeamViewerManager -APIToken $testAPIToken -Device $testDevice
            $Result | Should -HaveCount 2
            $Result[0].Device_Id | Should -Be $testDeviceId
        }
    }
}
