BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Set-TeamViewerPredefinedRole.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }

    $testApiToken = [securestring]@{}
    $null = $testApiToken
    $testRoleId = '9b465ea2-2f75-4101-a057-58a81ed0e57b'
    $null = $testRoleId

    Mock Get-TeamViewerApiUri { '//unit.test' }
    Mock Invoke-TeamViewerRestMethod
}

Describe 'Set-TeamViewerPredefinedRole' {
    It 'Should call the correct API endpoint' {
        Set-TeamViewerPredefinedRole -ApiToken $testApiToken -RoleId $testRoleId

        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And `
                $Uri -eq "//unit.test/userroles/$testRoleId/predefined" -And `
                $Method -eq 'Put'
        }
    }

}

