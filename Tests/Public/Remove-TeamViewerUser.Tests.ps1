BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Remove-TeamViewerUser.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }

    $testAPIToken = [securestring]@{}
    $null = $testAPIToken

    Mock Get-TeamViewerAPIUri { '//unit.test' }
    Mock Invoke-TeamViewerRestMethod { }
}

Describe 'Remove-TeamViewerUser' {
    It 'Should call the correct API endpoint' {
        Remove-TeamViewerUser -APIToken $testAPIToken -User 'u1234'

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $APIToken -eq $testAPIToken -and $Uri -eq '//unit.test/users/u1234' -and $Method -eq 'Delete' }
    }

    It 'Should accept group objects' {
        $testUser = @{ id = 'u1234' } | ConvertTo-TeamViewerUser

        Remove-TeamViewerUser -APIToken $testAPIToken -User $testUser

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $APIToken -eq $testAPIToken -and $Uri -eq '//unit.test/users/u1234' -and $Method -eq 'Delete' }
    }

    It 'Should fail for invalid group identifiers' {
        { Remove-TeamViewerUser -APIToken $testAPIToken -User 'invalid1234' } | Should -Throw
    }

    It 'Should accept pipeline input' {
        $testUser = @{ id = 'u1234' } | ConvertTo-TeamViewerUser
        $testUser | Remove-TeamViewerUser -APIToken $testAPIToken

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $APIToken -eq $testAPIToken -and $Uri -eq '//unit.test/users/u1234' -and $Method -eq 'Delete' }
    }

    It 'Should accept switch parameter "Permanent"' {
        $testUser = @{ id = 'u1234' } | ConvertTo-TeamViewerUser

        Remove-TeamViewerUser -APIToken $testAPIToken -User $testUser -Permanent

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $APIToken -eq $testAPIToken -and $Uri -eq '//unit.test/users/u1234?isPermanentDelete=true' -and $Method -eq 'Delete' }
    }
}
