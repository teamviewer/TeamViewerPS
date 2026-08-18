BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Remove-TeamViewerUserTFA.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }

    $testApiToken = [securestring]@{}
    $null = $testApiToken

    Mock Get-TeamViewerApiUri { '//unit.test' }
    Mock Invoke-TeamViewerRestMethod { }
}

Describe 'Remove-TeamViewerUser' {
    It 'Should call the correct API endpoint' {
        Remove-TeamViewerUserTFA -ApiToken $testApiToken -User 'u1234'

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -and $Uri -eq '//unit.test/users/u1234/tfa' -and $Method -eq 'Delete' }
    }

    It 'Should accept group objects' {
        $testUser = @{ id = 'u1234' } | ConvertTo-TeamViewerUser

        Remove-TeamViewerUserTFA -ApiToken $testApiToken -User $testUser

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -and $Uri -eq '//unit.test/users/u1234/tfa' -and $Method -eq 'Delete' }
    }

    It 'Should fail for invalid group identifiers' {
        { Remove-TeamViewerUserTFA -ApiToken $testApiToken -User 'invalid1234' } | Should -Throw
    }

    It 'Should accept pipeline input' {
        $testUser = @{ id = 'u1234' } | ConvertTo-TeamViewerUser
        $testUser | Remove-TeamViewerUserTFA -ApiToken $testApiToken

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -and $Uri -eq '//unit.test/users/u1234/tfa' -and $Method -eq 'Delete' }
    }
}
