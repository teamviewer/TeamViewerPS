BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\New-TeamViewerUserGroup.ps1"

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

Describe 'New-TeamViewerUserGroup' {
    It 'Should call the correct API endpoint' {
        New-TeamViewerUserGroup -APIToken $testAPIToken -Name $testUserGroupName

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $APIToken -eq $testAPIToken -and $Uri -eq '//unit.test/usergroups' -and $Method -eq 'Post' }
    }

    It 'Should include the given name in the request' {
        New-TeamViewerUserGroup -APIToken $testAPIToken -Name $testUserGroupName

        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $Body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $Body.name | Should -Be $testUserGroupName
    }

    It 'Should return a UserGroup object' {
        $Result = New-TeamViewerUserGroup -APIToken $testAPIToken -Name $testUserGroupName
        $Result | Should -Not -BeNullOrEmpty
        $Result | Should -BeOfType ([pscustomobject])
        $Result.PSObject.TypeNames | Should -Contain 'TeamViewerPS.UserGroup'
        $Result.id | Should -Be $testUserGroupId
        $Result.name | Should -Be $testUserGroupName
    }
}
