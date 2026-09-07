BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Set-TeamViewerUserGroup.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }

    $testAPIToken = [securestring]@{}
    $null = $testAPIToken
    $mockArgs = @{}
    $testUserGroupId = 1001
    $testUserGroupName = 'This is a test user group'

    Mock Get-TeamViewerAPIUri { '//unit.test' }
    Mock Invoke-TeamViewerRestMethod {
        $mockArgs.Body = $Body
        @{
            id   = $testUserGroupId
            name = $testUserGroupName
        }
    }
}

Describe 'Set-TeamViewerUserGroup' {
    It 'Should call the correct API endpoint' {
        Set-TeamViewerUserGroup -APIToken $testAPIToken -UserGroup $testUserGroupId -Name $testUserGroupName

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $APIToken -eq $testAPIToken -and $Uri -eq "//unit.test/usergroups/$testUserGroupId" -and $Method -eq 'Put' }
    }

    It 'Should handle domain object as input' {
        $testUserGroup = @{Id = $testUserGroupId; Name = 'test user group' } | ConvertTo-TeamViewerUserGroup

        Set-TeamViewerUserGroup -APIToken $testAPIToken -UserGroup $testUserGroup -Name $testUserGroupName

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $APIToken -eq $testAPIToken -and $Uri -eq "//unit.test/usergroups/$testUserGroupId" -and $Method -eq 'Put' }
    }

    It 'Should include the given name in the request' {
        Set-TeamViewerUserGroup -APIToken $testAPIToken -UserGroup $testUserGroupId -Name $testUserGroupName

        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $Body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $Body.name | Should -Be $testUserGroupName
    }

    It 'Should return a UserGroup object' {
        $Result = Set-TeamViewerUserGroup -APIToken $testAPIToken -UserGroup $testUserGroupId -Name $testUserGroupName

        $Result | Should -Not -BeNullOrEmpty
        $Result | Should -BeOfType ([pscustomobject])
        $Result.PSObject.TypeNames | Should -Contain 'TeamViewerPS.UserGroup'
        $Result.id | Should -Be $testUserGroupId
        $Result.name | Should -Be $testUserGroupName
    }
}
