
BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Remove-TeamViewerRole.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }

    $testAPIToken = [securestring]@{}
    $null = $testAPIToken
    $testRoleId = '2bcf19dc-d5a9-4d25-952e-7cbb21762c9a'
    $null = $testRoleId

    Mock Get-TeamViewerAPIUri { '//unit.test' }
    Mock Invoke-TeamViewerRestMethod {}
}

Describe 'Remove-TeamViewerRole' {
    It 'Should call the correct API endpoint' {
        Remove-TeamViewerRole -APIToken $testAPIToken -RoleId $testRoleId

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $APIToken -eq $testAPIToken -and $Uri -eq "//unit.test/userroles?userRoleId=$testRoleId" -and $Method -eq 'Delete'
        }
    }

    It 'Should handle domain object as input' {
        $testRole = @{Id = $testRoleId; Name = 'test user role' } | ConvertTo-TeamViewerRole

        Remove-TeamViewerRole -APIToken $testAPIToken -RoleId $testRole.ID

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $APIToken -eq $testAPIToken -and $Uri -eq "//unit.test/userroles?userRoleId=$testRoleId" -and $Method -eq 'Delete'
        }
    }
}
