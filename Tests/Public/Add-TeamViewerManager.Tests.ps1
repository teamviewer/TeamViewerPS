BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Add-TeamViewerManager.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }

    $testAPIToken = [securestring]@{}
    $null = $testAPIToken
    $testGroupId = '9e5617cb-2b20-4da2-bca4-c1bda85b29ab'
    $null = $testGroupId
    $testDeviceId = 'c37e72b8-b78d-467f-923c-6083c13cf82f'
    $null = $testDeviceId
    $testAccountId = 'u123456'
    $null = $testAccountId
    $testManagerId = '07f88e56-fe7c-4965-8f51-c8fb86f9cd0e'
    $null = $testManagerId

    Mock Get-TeamViewerAPIUri { '//unit.test' }
    $mockArgs = @{}
    Mock Invoke-TeamViewerRestMethod { $mockArgs.Body = $Body }
}

Describe 'Add-TeamViewerManager' {
    Context 'Parameter aliases' {
        It 'Should expose <Alias> as an alias of the <Param> parameter' -ForEach @(
            @{ Param = 'Device'; Alias = 'DeviceId' }
            @{ Param = 'Device'; Alias = 'ManagedDeviceId' }
            @{ Param = 'Device'; Alias = 'ManagedDevice' }
            @{ Param = 'Group'; Alias = 'GroupId' }
            @{ Param = 'Group'; Alias = 'ManagedGroupId' }
            @{ Param = 'Group'; Alias = 'ManagedGroup' }
        ) {
            (Get-Command -Name Add-TeamViewerManager).Parameters[$Param].Aliases | Should -Contain $Alias
        }
    }
    Context 'Group' {
        It 'Should call the correct API endpoint to add managed group managers' {
            Add-TeamViewerManager -APIToken $testAPIToken -GroupId $testGroupId -AccountId $testAccountId

            Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
                $APIToken -eq $testAPIToken -and $Uri -eq "//unit.test/managed/groups/$testGroupId/managers" -and $Method -eq 'Post' }
        }

        It 'Should add the manager to the group' {
            Add-TeamViewerManager -APIToken $testAPIToken -GroupId $testGroupId -AccountId $testAccountId -Permissions 'EasyAccess', 'ManagerAdministration'

            $mockArgs.Body | Should -Not -BeNullOrEmpty
            $Body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
            $Body.accountId | Should -Be '123456'
            $Body.permissions | Should -HaveCount 2
            $Body.permissions | Should -Contain 'EasyAccess'
            $Body.permissions | Should -Contain 'ManagerAdministration'
        }

        It 'Should accept group objects as input' {
            $groupObj = @{id = $testGroupId } | ConvertTo-TeamViewerManagedGroup

            Add-TeamViewerManager -APIToken $testAPIToken -Group $groupObj -AccountId $testAccountId

            Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
                $APIToken -eq $testAPIToken -and $Uri -eq "//unit.test/managed/groups/$testGroupId/managers" -and $Method -eq 'Post' }
        }
    }

    Context 'Device' {
        It 'Should call the correct API endpoint to add managed device managers' {
            Add-TeamViewerManager -APIToken $testAPIToken -DeviceId $testDeviceId -AccountId $testAccountId

            Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
                $APIToken -eq $testAPIToken -and $Uri -eq "//unit.test/managed/devices/$testDeviceId/managers" -and $Method -eq 'Post' }
        }

        It 'Should add the manager to the device' {
            Add-TeamViewerManager -APIToken $testAPIToken -DeviceId $testDeviceId -AccountId $testAccountId -Permissions 'EasyAccess', 'ManagerAdministration'

            $mockArgs.Body | Should -Not -BeNullOrEmpty
            $Body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
            $Body.accountId | Should -Be '123456'
            $Body.permissions | Should -HaveCount 2
            $Body.permissions | Should -Contain 'EasyAccess'
            $Body.permissions | Should -Contain 'ManagerAdministration'
        }

        It 'Should accept device objects as input' {
            $deviceObj = @{id = $testDeviceId } | ConvertTo-TeamViewerManagedDevice

            Add-TeamViewerManager -APIToken $testAPIToken -Device $deviceObj -AccountId $testAccountId

            Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
                $APIToken -eq $testAPIToken -and $Uri -eq "//unit.test/managed/devices/$testDeviceId/managers" -and $Method -eq 'Post' }
        }
    }

    It 'Should accept manager Id as input' {
        Add-TeamViewerManager -APIToken $testAPIToken -GroupId $testGroupId -ManagerId $testManagerId

        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $Body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $Body.id | Should -Be $testManagerId
    }

    It 'Should accept manager objects as input' {
        $managerObj = @{id = $testManagerId } | ConvertTo-TeamViewerManager -DeviceId (New-Guid)

        Add-TeamViewerManager -APIToken $testAPIToken -GroupId $testGroupId -Manager $managerObj

        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $Body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $Body.id | Should -Be $testManagerId
    }

    It 'Should accept a user object as input' {
        $userObj = @{id = $testAccountId } | ConvertTo-TeamViewerUser

        Add-TeamViewerManager -APIToken $testAPIToken -GroupId $testGroupId -User $userObj

        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $Body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $Body.accountId | Should -Be 123456
    }

    It 'Should accept a user group Id as input' {
        $TestUserGroupId = [uint64]123456

        Add-TeamViewerManager -APIToken $testAPIToken -GroupId $testGroupId -UserGroupId $TestUserGroupId

        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $Body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $Body.usergroupId | Should -Be $TestUserGroupId
    }

    It 'Should send a JSON array' {
        Add-TeamViewerManager -APIToken $testAPIToken -GroupId $testGroupId -AccountId $testAccountId

        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $BodyText = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body)
        $BodyText[0] | Should -Be '['
        $BodyText[$BodyText.Length - 1] | Should -Be ']'
    }

    It 'Should not invoke REST when WhatIf is used' {
        Add-TeamViewerManager -APIToken $testAPIToken -GroupId $testGroupId -AccountId $testAccountId -WhatIf

        Should -Invoke Invoke-TeamViewerRestMethod -Times 0 -Scope It
    }
}
