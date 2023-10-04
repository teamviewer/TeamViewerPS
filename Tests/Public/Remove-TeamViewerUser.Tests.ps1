BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Remove-TeamViewerUser.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | `
        ForEach-Object { . $_.FullName }

    $testApiToken = [securestring]@{}
    $null = $testApiToken

    Mock Get-TeamViewerApiUri { '//unit.test' }
    Mock Invoke-TeamViewerRestMethod { }
}

Describe 'Remove-TeamViewerUser' {
    It 'Should call the correct API endpoint' {
        Remove-TeamViewerUser -ApiToken $testApiToken -User 'u1234'

        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And `
                $Uri -eq '//unit.test/users/u1234' -And `
                $Method -eq 'Delete' }
    }

    It 'Should accept group objects' {
        $testUser = @{ id = 'u1234' } | ConvertTo-TeamViewerUser
        Remove-TeamViewerUser -ApiToken $testApiToken -User $testUser

        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And `
                $Uri -eq '//unit.test/users/u1234' -And `
                $Method -eq 'Delete' }
    }

    It 'Should fail for invalid group identifiers' {
        { Remove-TeamViewerUser -ApiToken $testApiToken -User 'invalid1234' } | Should -Throw
    }

    It 'Should accept pipeline input' {
        $testUser = @{ id = 'u1234' } | ConvertTo-TeamViewerUser
        $testUser | Remove-TeamViewerUser -ApiToken $testApiToken

        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And `
                $Uri -eq '//unit.test/users/u1234' -And `
                $Method -eq 'Delete' }
    }

    It 'Should accept switch parameter "Permanent"' {
        $testUser = @{ id = 'u1234' } | ConvertTo-TeamViewerUser
        Remove-TeamViewerUser -ApiToken $testApiToken -User $testUser -Permanent

        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And `
                $Uri -eq '//unit.test/users/u1234?isPermanentDelete=true' -And `
                $Method -eq 'Delete' }
    }
}
