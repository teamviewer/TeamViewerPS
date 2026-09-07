BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Get-TeamViewerMemberByRole.ps1"
    . "$PSScriptRoot\..\..\Cmdlets\Public\Get-TeamViewerUserByRole.ps1"
    . "$PSScriptRoot\..\..\Cmdlets\Public\Get-TeamViewerUserGroupByRole.ps1"
    . "$PSScriptRoot\..\..\Cmdlets\Public\Get-TeamViewerUserGroupMember.ps1"
    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }

    $testAPIToken = [securestring]@{}
    $null = $testAPIToken
    $testRoleId = '72abbedc-9853-4fc8-9d28-fa35e207b048'
    $null = $testRoleId

    Mock Get-TeamViewerUserByRole { [pscustomobject]@{ UserId = 'u100' } }
    Mock Get-TeamViewerUserGroupByRole { [pscustomobject]@{ UserGroupId = '42' } }
    Mock Get-TeamViewerUserGroupMember { [pscustomobject]@{ Id = 1001 } }
}

Describe 'Get-TeamViewerMemberByRole' {
    It 'Should return direct and indirect role members' {
        $Result = Get-TeamViewerMemberByRole -APIToken $testAPIToken -Role $testRoleId

        $Result | Should -HaveCount 3
        $Result[0].PSObject.TypeNames[0] | Should -Be 'TeamViewerPS.RoleMember'
        $Result[0].RoleId | Should -Be $testRoleId
        $Result[0].MemberType | Should -Be 'User'
        $Result[0].MemberId | Should -Be 'u100'
        $Result[0].MembershipType | Should -Be 'Direct'
        $Result[1].MemberType | Should -Be 'UserGroup'
        $Result[1].MemberId | Should -Be '42'
        $Result[1].MembershipType | Should -Be 'Direct'
        $Result[2].MemberType | Should -Be 'User'
        $Result[2].MemberId | Should -Be 1001
        $Result[2].MembershipType | Should -Be 'Indirect'
        $Result[2].Via_UserGroupId | Should -Be '42'
    }

    It 'Should use the focused public commands' {
        Get-TeamViewerMemberByRole -APIToken $testAPIToken -Role $testRoleId

        Should -Invoke Get-TeamViewerUserByRole -Times 1 -Scope It -ParameterFilter { $Role -eq $testRoleId }
        Should -Invoke Get-TeamViewerUserGroupByRole -Times 1 -Scope It -ParameterFilter { $Role -eq $testRoleId }
        Should -Invoke Get-TeamViewerUserGroupMember -Times 1 -Scope It -ParameterFilter { $UserGroup -eq '42' }
    }
}
