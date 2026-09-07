BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Set-TeamViewerManagedDevice.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }

    $testAPIToken = [securestring]@{}
    $null = $testAPIToken
    $testDeviceId = '9e5617cb-2b20-4da2-bca4-c1bda85b29ab'
    $null = $testDeviceId

    Mock Get-TeamViewerAPIUri { '//unit.test' }
    $mockArgs = @{}
    Mock Invoke-TeamViewerRestMethod { $mockArgs.Body = $Body }
}

Describe 'Set-TeamViewerManagedDevice' {
    Context 'Parameter aliases' {
        It 'Should expose <Alias> as an alias of the <Param> parameter' -ForEach @(
            @{ Param = 'Device'; Alias = 'Id' }
            @{ Param = 'Device'; Alias = 'DeviceId' }
            @{ Param = 'Device'; Alias = 'ManagedDeviceId' }
            @{ Param = 'Device'; Alias = 'ManagedDevice' }
            @{ Param = 'ManagedGroup'; Alias = 'GroupId' }
            @{ Param = 'ManagedGroup'; Alias = 'ManagedGroupId' }
        ) {
            (Get-Command -Name Set-TeamViewerManagedDevice).Parameters[$Param].Aliases | Should -Contain $Alias
        }
    }

    It 'Should call the correct API endpoint to update a managed device' {
        Set-TeamViewerManagedDevice -APIToken $testAPIToken -Device $testDeviceId -Name 'Foo Bar'

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $APIToken -eq $testAPIToken -and $Uri -eq "//unit.test/managed/devices/$testDeviceId" -and $Method -eq 'Put' }
    }

    It 'Should update the managed device alias' {
        Set-TeamViewerManagedDevice -APIToken $testAPIToken -Device $testDeviceId -Name 'Foo Bar'

        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $Body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $Body.name | Should -Be 'Foo Bar'
    }

    It 'Should update the managed device policy' {
        Set-TeamViewerManagedDevice -APIToken $testAPIToken -Device $testDeviceId -Policy '2871c013-3040-4969-9ba4-ce970f4375e8'

        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $Body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $Body.teamviewerPolicyId | Should -Be '2871c013-3040-4969-9ba4-ce970f4375e8'
    }

    It 'Should update the managed device policy to the managed group' {
        Set-TeamViewerManagedDevice -APIToken $testAPIToken -Device $testDeviceId -ManagedGroup 'e579cfeb-0b29-4d91-9e81-2d9507f53ff8'

        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $Body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $Body.managedGroupId | Should -Be 'e579cfeb-0b29-4d91-9e81-2d9507f53ff8'
    }

    It 'Should update the managed device alias and the managed device policy to the managed group' {
        Set-TeamViewerManagedDevice -APIToken $testAPIToken -Device $testDeviceId -Name 'Foo Bar' -ManagedGroup 'e579cfeb-0b29-4d91-9e81-2d9507f53ff8'

        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $Body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $Body.name | Should -Be 'Foo Bar'
        $Body.managedGroupId | Should -Be 'e579cfeb-0b29-4d91-9e81-2d9507f53ff8'
    }

    It 'Should update the managed device description' {

        Set-TeamViewerManagedDevice -APIToken $testAPIToken -Device $testDeviceId -Description 'Test description'
        $mockArgs.Body | Should -Not -BeNullOrEmpty

        $Body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $Body.deviceDescription | Should -Be 'Test description'

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $APIToken -eq $testAPIToken -and $Uri -eq "//unit.test/managed/devices/$testDeviceId/description" -and $Method -eq 'Put'
        }
    }

    It 'Should not allow description together with policy' {
        { Set-TeamViewerManagedDevice -APIToken $testAPIToken -Device $testDeviceId -Description 'Test description' -Policy '2871c013-3040-4969-9ba4-ce970f4375e8' } | Should -Throw
    }

    It 'Should not allow description together with managed group' {
        { Set-TeamViewerManagedDevice -APIToken $testAPIToken -Device $testDeviceId -Description 'Test description' -ManagedGroup 'e579cfeb-0b29-4d91-9e81-2d9507f53ff8' } | Should -Throw
    }

    It 'Should not be possible to inherit and set a policy at the same time' {
        { Set-TeamViewerManagedDevice -APIToken $testAPIToken -Device $testDeviceId -Policy '2871c013-3040-4969-9ba4-ce970f4375e8' -ManagedGroup '6808db5b-f3c1-4e42-8168-3ac96f5d456e' } | Should -Throw
    }

    It 'Should not be possible to use "none" or "inherit" as values for policy' {
        { Set-TeamViewerManagedDevice -APIToken $testAPIToken -Device $testDeviceId -Policy 'none' } | Should -Throw
        { Set-TeamViewerManagedDevice -APIToken $testAPIToken -Device $testDeviceId -Policy 'inherit' } | Should -Throw
    }

    It 'Should accept a ManagedDevice object as input' {
        $testDevice = @{ id = $testDeviceId; name = 'test device' } | ConvertTo-TeamViewerManagedDevice

        Set-TeamViewerManagedDevice -APIToken $testAPIToken -Device $testDevice -Name 'Foo Bar'

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $APIToken -eq $testAPIToken -and $Uri -eq "//unit.test/managed/devices/$testDeviceId" -and $Method -eq 'Put' }
    }

    It 'Should throw an error when called without changes' {
        { Set-TeamViewerManagedDevice -APIToken $testAPIToken -Device $testDeviceId } | Should -Throw
    }
}
