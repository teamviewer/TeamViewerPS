BeforeAll {
    . "$PSScriptRoot/../../Docs/Cmdlets/Public/Remove-TeamViewerUserGroup.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot/../../Docs/Cmdlets/Private/*.ps1") | `
        ForEach-Object { . $_.FullName }

    $testApiToken = [securestring]@{}
    $null = $testApiToken
    $testUserGroupId = 1001
    $null = $testUserGroupId

    Mock Get-TeamViewerApiUri { '//unit.test' }
    Mock Invoke-TeamViewerRestMethod {}
}

Describe 'Remove-TeamViewerUserGroup' {

    It 'Should call the correct API endpoint' {
        Remove-TeamViewerUserGroup -ApiToken $testApiToken -UserGroup $testUserGroupId

        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And `
            $Uri -eq "//unit.test/usergroups/$testUserGroupId" -And `
            $Method -eq 'Delete'
        }
    }

    It 'Should handle domain object as input' {
        $testUserGroup = @{Id = $testUserGroupId; Name = 'test user group' } | ConvertTo-TeamViewerUserGroup
        Remove-TeamViewerUserGroup -ApiToken $testApiToken -UserGroup $testUserGroup

        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And `
            $Uri -eq "//unit.test/usergroups/$testUserGroupId" -And `
            $Method -eq 'Delete'
        }
    }
}
