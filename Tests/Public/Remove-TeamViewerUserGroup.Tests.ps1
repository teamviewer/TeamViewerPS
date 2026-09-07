BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Remove-TeamViewerUserGroup.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }

    $testAPIToken = [securestring]@{}
    $null = $testAPIToken
    $testUserGroupId = 1001
    $null = $testUserGroupId

    Mock Get-TeamViewerAPIUri { '//unit.test' }
    Mock Invoke-TeamViewerRestMethod {}
}

Describe 'Remove-TeamViewerUserGroup' {
    It 'Should call the correct API endpoint' {
        Remove-TeamViewerUserGroup -APIToken $testAPIToken -UserGroup $testUserGroupId

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $APIToken -eq $testAPIToken -and $Uri -eq "//unit.test/usergroups/$testUserGroupId" -and $Method -eq 'Delete'
        }
    }

    It 'Should handle domain object as input' {
        $testUserGroup = @{Id = $testUserGroupId; Name = 'test user group' } | ConvertTo-TeamViewerUserGroup

        Remove-TeamViewerUserGroup -APIToken $testAPIToken -UserGroup $testUserGroup

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $APIToken -eq $testAPIToken -and $Uri -eq "//unit.test/usergroups/$testUserGroupId" -and $Method -eq 'Delete'
        }
    }
}
