
BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Remove-TeamViewerRole.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | `
        ForEach-Object { . $_.FullName }

    $testApiToken = [securestring]@{}
    $null = $testApiToken
    $testUserRoleId = '2bcf19dc-d5a9-4d25-952e-7cbb21762c9a'
    $null = $testUserRoleId

    Mock Get-TeamViewerApiUri { '//unit.test' }
    Mock Invoke-TeamViewerRestMethod {}
}
Describe 'Remove-TeamViewerRole' {
    It 'Should call the correct API endpoint' {
        Remove-TeamViewerRole -ApiToken $testApiToken -UserRoleId $testUserRoleId

        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And `
                $Uri -eq "//unit.test/userroles?userRoleId=$testUserRoleId" -And `
                $Method -eq 'Delete'
        }
    }

    It 'Should handle domain object as input' {
        $testUserRole = @{Id = $testUserRoleId; Name = 'test user role' } | ConvertTo-TeamViewerRole
        Remove-TeamViewerRole -ApiToken $testApiToken -UserRoleId $testUserRole.RoleID

        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And `
                $Uri -eq "//unit.test/userroles?userRoleId=$testUserRoleId" -And `
                $Method -eq 'Delete'
        }
    }
}
