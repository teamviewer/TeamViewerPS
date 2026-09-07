BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Set-TeamViewerDefaultRole.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }

    $testAPIToken = [securestring]@{}
    $null = $testAPIToken
    $testRoleId = '9b465ea2-2f75-4101-a057-58a81ed0e57b'
    $null = $testRoleId

    Mock Get-TeamViewerAPIUri { '//unit.test' }
    Mock Invoke-TeamViewerRestMethod
}

Describe 'Set-TeamViewerDefaultRole' {
    It 'Should call the correct API endpoint' {
        Set-TeamViewerDefaultRole -APIToken $testAPIToken -RoleId $testRoleId

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $APIToken -eq $testAPIToken -and $Uri -eq "//unit.test/userroles/$testRoleId/predefined" -and $Method -eq 'Put'
        }
    }
}
